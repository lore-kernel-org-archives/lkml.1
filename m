Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbXLPAVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbXLPAVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbXLPAU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:20:56 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:21280 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbXLPAUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eRnhgeofBGTfZ0JfOc4jPu67oASZUbCyV9R0h08QCea+G7+sb9pEXjlBCaTyvP46FTysrmopK6/rhi/9SDfEtVpA5pNVMfWu5/aV3TuKf7LSyHE/wVArpdULs5lbL8wtKPI7D7TPvDf2mRYS+sD2+psBDiwXZt0LRBsz2WR0pAU=
Message-ID: <8b67d60712151620s331281f4s7e150aacacff4400@mail.gmail.com>
Date: Sun, 16 Dec 2007 00:20:54 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, "Paul Mundt" <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org, axboe@kernel.dk, linux-ide@vger.kernel.org
Subject: [PATCH 0/3] Add GD-Rom support to the SEGA Dreamcast
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Apologies if you've already had this. I sent it to lkml etc an hour
ago but it just disappeated into the ether - trying it in smaller
packets this time.)

This patch adds support for the CD drive on the SEGA Dreamcast - the
so-called GD Rom drive.

This device is electrically compatible with ATA-3 IDE CD drives but
implements a proprietary packet interface. There have been previous
Dreamcast CD drivers around but this is new code and uses DMA as
opposed to PIO for reads.

It also supports reading the proprietary GD Rom format disks.

The driver will live as drivers/sh/gdrom/gdrom.c

This has been tested against the latest git in Paul Mundt's 2.6.25
queue as well as 2.6.24-rc5

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
