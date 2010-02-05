Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab0BEOhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:37:21 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:49631 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0BEOhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nHohKSG0v+zML1zS7IPgotzKg//+CC0vlulpSegHYmjizTSXOLrOMgSYzWB5CMVr9D
         nyvQ2jyUYE9bmIjcjhTb6XrTq6/tHTip6wV8+qmkpckLmALS03VctWcW8WGzfFvYA6RI
         NeoWwhhMPX6Apyc1rFDiKlu/Z3HJ7W+j3faL4=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] x86: Merge 32-bit and 64-bit io.h
Date: Fri,  5 Feb 2010 09:37:02 -0500
Message-Id: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up and merges the 32-bit and 64-bit implementations
of io.h

[PATCH 1/7] x86-32: Move XQUAD definitions to numaq.h
[PATCH 2/7] x86-32: Remove _local variants of in/out from io_32.h
[PATCH 3/7] x86-64: Reorganize io_64.h
[PATCH 4/7] x86-64: Use BUILDIO in io_64.h
[PATCH 5/7] x86: Clean up mem*io functions.
[PATCH 6/7] x86: Simplify flush_write_buffers()
[PATCH 7/7] x86: Merge io.h

 arch/x86/boot/compressed/misc.c |   13 +--
 arch/x86/include/asm/io.h       |  155 ++++++++++++++++++++++++++++++-
 arch/x86/include/asm/io_32.h    |  196 ---------------------------------------
 arch/x86/include/asm/io_64.h    |  181 ------------------------------------
 arch/x86/include/asm/numaq.h    |    4 +
 arch/x86/lib/Makefile           |    2 +-
 arch/x86/lib/io_64.c            |   25 -----
 arch/x86/pci/numaq_32.c         |    6 +-
 8 files changed, 162 insertions(+), 420 deletions(-)

