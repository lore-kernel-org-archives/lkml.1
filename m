Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYA3VEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYA3VEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYA3VEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:04:34 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:52248 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYA3VEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=Sl+NSUXlnWpR54g4arb5GJZx4+Ww2To+8yDuTPIwY0dDeiRUV4nZYUbBQ5/Be4+z87lQpMgDnQdYDegyLVsi+Qo30WhYYxodQxHOwONpYFcFiUY5evm16H6Z9wwSAioIkiiOp6kc71PXBvN9rBkp8ClE+NF+gOOVJh/Fd/S2law=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 00/10] udf: cleanups
Date: Wed, 30 Jan 2008 22:03:50 +0100
Message-Id: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patchset contains various UDF fs cleanups.

[PATCH 01/10] udf: udf_CS0toUTF8 cleanup
[PATCH 02/10] udf: fix udf_build_ustr
[PATCH 03/10] udf: udf_CS0toNLS cleanup
[PATCH 04/10] udf: constify crc
[PATCH 05/10] udf: simple cleanup of truncate.c
[PATCH 06/10] udf: truncate: create function for updating of Allocation Ext Descriptor
[PATCH 07/10] udf: replace all adds to little endians variables with le*_add_cpu
[PATCH 08/10] udf: simplify __udf_read_inode
[PATCH 09/10] udf: replace udf_*_offset macros with functions
[PATCH 10/10] udf: constify udf_bitmap_lookup array

 fs/udf/balloc.c          |   13 +---
 fs/udf/crc.c             |    4 -
 fs/udf/ialloc.c          |   12 +---
 fs/udf/inode.c           |   68 +++++++++---------------
 fs/udf/super.c           |    2 
 fs/udf/truncate.c        |  132 ++++++++++++++++++++---------------------------
 fs/udf/udfdecl.h         |   33 +++++++----
 fs/udf/unicode.c         |   58 ++++++++------------
 include/linux/udf_fs_i.h |    4 -
 9 files changed, 142 insertions(+), 184 deletions(-)

This patchset depends on udf and byteorder patches (all in -mm).

Marcin Slusarz
