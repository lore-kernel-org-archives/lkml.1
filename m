Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYC0FUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYC0FUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 01:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYC0FUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 01:20:19 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49882 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYC0FUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 01:20:13 -0400
Date: Wed, 26 Mar 2008 23:20:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: DMA not working on SATA?
In-reply-to: <fa.tM6egqVO3jg78PMZEi2Ne7NkjtI@ifi.uio.no>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <47EB2E92.9060401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tM6egqVO3jg78PMZEi2Ne7NkjtI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Bennee wrote:
> Hi,
> 
> Since I got my new machine I noticed it seemed to be running slower than
> I expected for a duel core machine including a lot of stuttering. After
> tweaking the BIOS settings from "Legacy" to "AHCI" I measured a doubling
> of read performance with hdparm but heavy IO still makes the machine
> sluggish, with top showing ~80% of the time in the wait state (and
> loadavg shooting up). This seems like a DMA problem because I was under
> the impression a task demanding IO should be able to sleep on a DMA
> completion rather than blocking everything else.

That's not what IOwait means. It basically means "nothing better to do 
than wait for IO to complete". If you have only one running task which 
is blocked waiting for IO you will always have high IOwait.
