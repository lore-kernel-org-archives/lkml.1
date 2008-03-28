Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYC1SJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYC1SJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbYC1SJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:09:40 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50606 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbYC1SJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:09:39 -0400
Message-ID: <47ED3441.3090601@freescale.com>
Date: Fri, 28 Mar 2008 13:09:05 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: York Sun <yorksun@freescale.com>, linux-fbdev-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2 v4] Driver for Freescale 8610 and 5121 DIU
References: <12066720572512-git-send-email-yorksun@freescale.com> <12066720572314-git-send-email-yorksun@freescale.com> <47ED2B35.4030601@freescale.com> <47ED33C6.3090202@freescale.com>
In-Reply-To: <47ED33C6.3090202@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> Scott Wood wrote:
> 
>> ...but not anywhere else.  All user pointers should have a __user 
>> annotation.
> 
> Even in a typecast?

Yes.  Otherwise, as far as sparse sees, you're passing a kernel pointer 
to something expecting a user pointer.

-Scott
