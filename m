Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYBQD5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYBQD5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYBQD5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 22:57:38 -0500
Received: from rtr.ca ([76.10.145.34]:4091 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbYBQD5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 22:57:37 -0500
Message-ID: <47B7B0AD.2080100@rtr.ca>
Date: Sat, 16 Feb 2008 22:57:33 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de> <47B77B3F.1000909@garzik.org> <je1w7c5rx5.fsf@sykes.suse.de>
In-Reply-To: <je1w7c5rx5.fsf@sykes.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Andreas Schwab wrote:
>>> Since commit aaa04c28cb9a1efd42541fdb7ab648231c2a2263 [blk_end_request:
>>> changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the
>>> following error from wodim:
>>>
>>> Errno: 0 (Success), write_g1 scsi sendcmd: no error
>>> CDB:  2A 00 00 00 00 00 00 00 1F 00
>>> status: 0x2 (CHECK CONDITION)
>>> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00
>>> Sense Key: 0x5 Illegal Request, Segment 0
>>> Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0
>>> Sense flags: Blk 0 (not valid) resid: 63488
>> Does libata on the same hardware work?
> 
> There is no libata driver for ide-pmac.
..

What chipset is that..  CMD646 ?
