Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYBPFwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYBPFwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 00:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYBPFwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 00:52:24 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28068 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYBPFwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 00:52:23 -0500
Date: Fri, 15 Feb 2008 23:52:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
In-reply-to: <fa.wuwhrqFp6CufvpAJxShHqIaOPdI@ifi.uio.no>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47B67A0E.7060605@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.LKjQjbOw482S/QFVaQ9fSrM+IFw@ifi.uio.no>
 <fa.wuwhrqFp6CufvpAJxShHqIaOPdI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>> [akpm@linux-foundation.org: many fixes and cleanups]
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>> Signed-off-by: Andi Kleen <ak@suse.de>
>> Tested-by: Andi Kleen <ak@suse.de>
> 
> iirc it really was 
> Tested-and-didnt-pass-test-by: Andi Kleen 
> unfortunately. I have not rechecked recently, but on the one Intel
> box the original patch and the other mcfg heuristics removed didn't work.

With just this patch you will have this problem. You need either the 
patch to disable decode during BAR sizing, or the patch to use MMCONFIG 
for extended config space only, if you don't have them already.
