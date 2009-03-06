Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZCFUYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZCFUYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZCFUYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:24:32 -0500
Received: from adsl99-243.ath.forthnet.gr ([79.103.126.243]:52938 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZCFUYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:24:31 -0500
Message-ID: <49B18679.4030504@asyr.hopto.org>
Date: Fri, 06 Mar 2009 22:24:25 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: jffs2 and kernel config for SDHC Memory Cards
References: <49B127AB.6070202@asyr.hopto.org> <49B12B71.7030300@asyr.hopto.org> <20090306182425.GB28349@silver.sucs.org>
In-Reply-To: <20090306182425.GB28349@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 03/06/2009 08:24 PM Sitsofe Wheeler wrote the following:
> On Fri, Mar 06, 2009 at 03:56:01PM +0200, Thanasis wrote:
>> on 03/06/2009 03:39 PM Thanasis wrote the following:
>>> I want to use two of these Transcend¢s Class 6 SDHC (SD High-Capacity)
>>> Memory Cards,
>>> http://www.transcendusa.com/Products/ModDetail.asp?ModNo=147&LangNo=0&Func1No=1&Func2No=13
>>> as part of the filesystem in a netbook (Acer A110L), will mount /home on
>>> one, and /tmp and /var on the other.
>  
>> Let me rephrase my questions in order to be clearer:
>> Q1: In order to achieve wear leveling should I format them as jffs2?
> 
> This probably won't be very effective as you are already past the
> anecdotal size recommended for jffs2 partitions (I've heard rumours that
> it is best suited to filesystems that are less than 64Mbytes and another
> that says less than 1Gbyte). Additionally you are not providing direct
> access to the raw flash (see
> http://linux-mtd.infradead.org/faq/jffs2.html#L_stick_jffs2 ).
> Performance is probably not gong to be very good.
> 
>> Q2: In order to achieve wear leveling, any specific options I should
>> enable in kernel (2.6.28) configuration?
> 
> You will be wear levelled by the hardware anyway as the hardware only
> provides a block device interface and you don't have access to the raw
> flash. 
> 
> ccing Dave Woodhouse as he is the JFFS2 creator.
> 
OK. I believe I should stick to ext2, right?
Thanks ;-)
