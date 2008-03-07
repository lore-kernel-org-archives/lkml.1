Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbYCGPSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbYCGPSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYCGPSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:18:36 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:60886 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbYCGPSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:18:35 -0500
Message-ID: <47D15CDF.5060501@keyaccess.nl>
Date: Fri, 07 Mar 2008 16:18:55 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
References: <200803071007.493903088@firstfloor.org>
In-Reply-To: <200803071007.493903088@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-03-08 10:07, Andi Kleen wrote:

> it to any size needed (upto 2GB currently). The default sizing 
> heuristics are for now the same as in the old code: by default
> all free memory below 16MB is put into the pool (in practice that
> is only ~8MB or so usable because the kernel is loaded there too)

Just a side-comment -- not necessarily, given CONFIG_PHYSICAL_START.

Rene.
