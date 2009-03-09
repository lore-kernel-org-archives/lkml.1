Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZCIVGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZCIVGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZCIVGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:06:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:42438 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZCIVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:06:32 -0400
Message-ID: <49B5813F.5040303@freescale.com>
Date: Mon, 09 Mar 2009 15:51:11 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add function spin_event_timeout()
References: <1236384801-10305-1-git-send-email-timur@freescale.com>	 <adaiqmmf87v.fsf@cisco.com> <ed82fe3e0903061725y40dc246ehd3482690ee3898fa@mail.gmail.com> <49B58076.8020703@goop.org>
In-Reply-To: <49B58076.8020703@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> A jiffy is a really long time to be spinning, let alone liffies plural.  
> In this use case are you expecting that the loop will iterate a very 
> small number of times before returning, and the timeout case is a very 
> unlikely error condition?

Yes, in version 3 of this patch, I switch to using udelay().  I might
need to post a v4 though.

-- 
Timur Tabi
Linux kernel developer at Freescale
