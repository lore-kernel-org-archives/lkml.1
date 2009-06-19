Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZFSHVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZFSHVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFSHU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:20:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52951
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbZFSHU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:20:57 -0400
Date: Fri, 19 Jun 2009 00:21:01 -0700 (PDT)
Message-Id: <20090619.002101.45610359.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: backtrace symbols are bolixed...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sometime in the last day or so backtrace symbol printouts
have become useless:

[    0.000000] WARNING: at mm/bootmem.c:535 __stop_notes+0xbb10/0x1d660()
[    0.000000] Modules linked in:
[    0.000000] Call Trace:
[    0.000000]  [00000000008611b4] __stop_notes+0xbb10/0x1d660
[    0.000000]  [000000000086195c] __stop_notes+0xc2b8/0x1d660
[    0.000000]  [0000000000861a28] __stop_notes+0xc384/0x1d660
[    0.000000]  [0000000000858678] __stop_notes+0x2fd4/0x1d660
[    0.000000]  [000000000085684c] __stop_notes+0x11a8/0x1d660
[    0.000000]  [00000000006e8bdc] _etext+0xfffffffffffe59f4/0xe18
[    0.000000]  [0000000000000000] (null)

I'll try to bisect but maybe someone can figure it out quickly
meanwhile.
