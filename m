Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbZCGQ7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbZCGQ7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 11:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZCGQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 11:59:35 -0500
Received: from adsl99-243.ath.forthnet.gr ([79.103.126.243]:50906 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZCGQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 11:59:34 -0500
Message-ID: <49B2A7F0.1090101@asyr.hopto.org>
Date: Sat, 07 Mar 2009 18:59:28 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090307)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: jffs2 and kernel config for SDHC Memory Cards
References: <49B127AB.6070202@asyr.hopto.org> <49B12B71.7030300@asyr.hopto.org> <20090306182425.GB28349@silver.sucs.org> <49B18679.4030504@asyr.hopto.org> <20090306225746.GB25593@silver.sucs.org>
In-Reply-To: <20090306225746.GB25593@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 03/07/2009 12:57 AM Sitsofe Wheeler wrote the following:
> On Fri, Mar 06, 2009 at 10:24:25PM +0200, Thanasis wrote:
>> on 03/06/2009 08:24 PM Sitsofe Wheeler wrote the following:
>>> On Fri, Mar 06, 2009 at 03:56:01PM +0200, Thanasis wrote:
>>>> on 03/06/2009 03:39 PM Thanasis wrote the following:
>>>>> I want to use two of these Transcend¢s Class 6 SDHC (SD High-Capacity)
>>>>> Memory Cards,
>>>>> http://www.transcendusa.com/Products/ModDetail.asp?ModNo=147&LangNo=0&Func1No=1&Func2No=13
>>>>> as part of the filesystem in a netbook (Acer A110L), will mount /home on
>>>>> one, and /tmp and /var on the other.
>>>  
>>>> Let me rephrase my questions in order to be clearer:
>>>> Q1: In order to achieve wear leveling should I format them as jffs2?
>>> This probably won't be very effective as you are already past the
> 
>> OK. I believe I should stick to ext2, right?
> 
> If you mean compared to jffs2 then probably yes, better to stick with
> ext2. 
Right, that is what I meant.

If you mean is ext2 the best choice over anything else... well
> that's an open question (or so I'm told). You would need to ask a
> filesystem expert really but it apparently depends on the workload, the
> characteristics of the "disks" and whether you need journaling.
It is going to be a desktop (netbook) system, so, if it had a HDD, I
would opt for ext4 or xfs, but given the hardware (SDHC), I guess ext2
is the best choice.
