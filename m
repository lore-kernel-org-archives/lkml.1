Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbXKNLCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbXKNLCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXKNLCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:02:40 -0500
Received: from mail.syneticon.net ([213.239.212.131]:55999 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXKNLCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:02:39 -0500
Message-ID: <473AD5C5.4030803@wpkg.org>
Date: Wed, 14 Nov 2007 12:02:29 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Strage buffer behaviour
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:

> On Sunday 11 November 2007 11:33, Tino Keitel wrote:
>> The dd command reads 100 MB from each partition two times in a row. It
>> looks like sda1 and sda2 are not bufferd (the first 4 dd runs), but
>> sda3 and sda4 are (the last 4 dd runs).
>>
>> The computer is a Mac mini with a 2,5" SATA hard disk. The first 2
>> partitions contain EFI and MacOS X, and are unused in Linux. The last 2
>> partitions are an ext3 partition for / and an LVM for the rest of the
>> sytem.
>>
>> Any hints how the dd/buffering behaviour could be explained? The system
>> was mostly idle, and the numbers are reproducible across reboots.
> 
> IIRC only mounted partitions' reads are cached.

Or, in general, those devices which kernel actually "uses" (mounted, but 
also LVM, RAID, which don't have to be mounted to get cached).


-- 
Tomasz Chmielewski
http://lists.wpkg.org
