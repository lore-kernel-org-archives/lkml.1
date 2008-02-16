Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYBPUwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYBPUwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYBPUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:52:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:50804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbYBPUwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:52:23 -0500
From: Andreas Schwab <schwab@suse.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc1/2 CD/DVD burning broken
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Yow: I will invent "TIDY BOWL"...
Date: Sat, 16 Feb 2008 21:52:21 +0100
Message-ID: <jelk5k62uy.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit aaa04c28cb9a1efd42541fdb7ab648231c2a2263 [blk_end_request:
changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the
following error from wodim:

Errno: 0 (Success), write_g1 scsi sendcmd: no error
CDB:  2A 00 00 00 00 00 00 00 1F 00
status: 0x2 (CHECK CONDITION)
Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00
Sense Key: 0x5 Illegal Request, Segment 0
Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0
Sense flags: Blk 0 (not valid) 
resid: 63488

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
