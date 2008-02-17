Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYBQJdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYBQJdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 04:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYBQJdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 04:33:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:55776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYBQJde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 04:33:34 -0500
From: Andreas Schwab <schwab@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de> <47B77B3F.1000909@garzik.org>
	<je1w7c5rx5.fsf@sykes.suse.de> <47B7B0AD.2080100@rtr.ca>
X-Yow: You were s'posed to laugh!
Date: Sun, 17 Feb 2008 10:33:30 +0100
In-Reply-To: <47B7B0AD.2080100@rtr.ca> (Mark Lord's message of "Sat\, 16 Feb
	2008 22\:57\:33 -0500")
Message-ID: <jefxvs3p1x.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <lkml@rtr.ca> writes:

> Andreas Schwab wrote:
>> Jeff Garzik <jeff@garzik.org> writes:
>>
>>> Andreas Schwab wrote:
>>>> Since commit aaa04c28cb9a1efd42541fdb7ab648231c2a2263 [blk_end_request:
>>>> changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the
>>>> following error from wodim:
>>>>
>>>> Errno: 0 (Success), write_g1 scsi sendcmd: no error
>>>> CDB:  2A 00 00 00 00 00 00 00 1F 00
>>>> status: 0x2 (CHECK CONDITION)
>>>> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00
>>>> Sense Key: 0x5 Illegal Request, Segment 0
>>>> Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0
>>>> Sense flags: Blk 0 (not valid) resid: 63488
>>> Does libata on the same hardware work?
>>
>> There is no libata driver for ide-pmac.
> ..
>
> What chipset is that..  CMD646 ?

Apple KeyLargo ATA-3 and Apple K2 ATA-6.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
