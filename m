Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYH1WEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYH1WEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYH1WEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:04:44 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:57632 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYH1WEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:04:43 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48B71ADD.601@avtrex.com>
Date: Thu, 28 Aug 2008 14:38:37 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/6] MIPS: Hardware watch register support for gdb (version
 3).
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Aug 2008 21:38:38.0209 (UTC) FILETIME=[6E79E710:01C90956]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Esteemed kernel hackers,

To follow is my third pass at MIPS watch register support.

This version has been tested on:

* MIPS 4KEc (mips32) with a single set of watch registers watchhi not
  reporting I, R, and W conditions.

* MIPS 4KEc (mips32r2) with four sets of watch registers.

* R5000 SGI O2 (mips4 64bit) with no watch register support.

The patches are against 2.6.27-rc4


Changes from the previous version:

* Agreement from gdb maintainers that the ptrace interface is
  workable.

* Work around for watchhi registers that do not report the I, R, and W
  condition bits.

* General cleanup, including making much less code conditionally
  compiled.

To really test the patch you will need a patched gdb.  My current gdb
patch is here:

http://sourceware.org/ml/gdb-patches/2008-08/msg00650.html

If you have any comments or questions please let me know.

David Daney
