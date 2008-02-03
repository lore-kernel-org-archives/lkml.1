Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYBCSgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYBCSgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYBCSgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:36:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:28629 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYBCSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=x2YKyjvBof/n+YAVe9O4T7C4pob5lCIfonwc7YSgHRnz0p6DAITxYph9690qZ6TEBFoFfCKrd7OBlCvl+HQLNEZYjnhU5QhKnvAX9zigiGD7EAddyW23QsjMdUwJsWAjKas8H8NslfP1Erlelr3qXdLEXRSkRCfrS8Fms+p4TsQ=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 0/6] udf: next round of cleanups
Date: Sun,  3 Feb 2008 19:36:05 +0100
Message-Id: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patchset contains next round of various UDF fs cleanups.

[PATCH 1/6] udf: udf_get_block, inode_bmap - remove unneeded checks

[PATCH 2/6] udf: create function for conversion from timestamp to timespec
[PATCH 3/6] udf: convert udf_stamp_to_time to return struct timespec
[PATCH 4/6] udf: convert udf_stamp_to_time and udf_time_to_stamp to use timestamps
[PATCH 5/6] udf: remove unneeded kernel_timestamp type
These 4 patches can be folded into one if requested, but I think it's
easier to analyze them when they are split.

[PATCH 6/6] udf: super.c reorganization
Pretty mechanical work. Can be dropped and redone if it will
conflict with someone else patch.

 fs/udf/ecma_167.h |   13 -
 fs/udf/inode.c    |  183 ++++++-----------
 fs/udf/super.c    |  553 ++++++++++++++++++++++++++----------------------------
 fs/udf/udfdecl.h  |    8 
 fs/udf/udfend.h   |   22 --
 fs/udf/udftime.c  |   39 +--
 6 files changed, 358 insertions(+), 460 deletions(-)

Applies on top of patches I've sent lately (http://lkml.org/lkml/2008/1/30/482)

Jan: Are you going to create git tree for udf?

Marcin Slusarz
