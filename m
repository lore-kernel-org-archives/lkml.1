Return-Path: <linux-kernel-owner+w=401wt.eu-S1763579AbYCGPWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763579AbYCGPWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbYCGPVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:21:53 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54393 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762046AbYCGPVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:21:52 -0500
Message-ID: <47D15DA4.2030500@keyaccess.nl>
Date: Fri, 07 Mar 2008 16:22:12 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
References: <200803071007.493903088@firstfloor.org> <47D15CDF.5060501@keyaccess.nl>
In-Reply-To: <47D15CDF.5060501@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-03-08 16:18, Rene Herman wrote:

> On 07-03-08 10:07, Andi Kleen wrote:
> 
>> it to any size needed (upto 2GB currently). The default sizing 
>> heuristics are for now the same as in the old code: by default
>> all free memory below 16MB is put into the pool (in practice that
>> is only ~8MB or so usable because the kernel is loaded there too)
> 
> Just a side-comment -- not necessarily, given CONFIG_PHYSICAL_START.

By the way, 1/13 didn't make it to LKML.

Rene.
