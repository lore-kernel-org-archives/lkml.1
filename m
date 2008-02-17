Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYBQAJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYBQAJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 19:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYBQAJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 19:09:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44919 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYBQAJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 19:09:38 -0500
Message-ID: <47B77B3F.1000909@garzik.org>
Date: Sat, 16 Feb 2008 19:09:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: linux-kernel@vger.kernel.org, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de>
In-Reply-To: <jelk5k62uy.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Since commit aaa04c28cb9a1efd42541fdb7ab648231c2a2263 [blk_end_request:
> changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the
> following error from wodim:
> 
> Errno: 0 (Success), write_g1 scsi sendcmd: no error
> CDB:  2A 00 00 00 00 00 00 00 1F 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00
> Sense Key: 0x5 Illegal Request, Segment 0
> Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0
> Sense flags: Blk 0 (not valid) 
> resid: 63488

Does libata on the same hardware work?

	Jeff



