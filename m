Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXLXAJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXLXAJC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:09:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXLXAIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:08:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:34930 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXLXAIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:08:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=L4V/uOy+lOE9ti1cIVv9bzmrJ/MaznWQ0NiWTGHtyO8SdLVNLKFH0hbH0ieewkQig6JeSvE9FYGG1s6VQjjo3h4Ux8H2Y/hNzfBhlc97+mUQV0Hz8s0TaoNABC9YN7duO8ULJ1QbRxqnoIdGpIDUgKUCVSwJNoGBbhOM6pWK2IU=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 0/6] udf: improve code related to super_block, was: udf: convert super_block macros to functions
Date: Mon, 24 Dec 2007 01:10:16 +0100
Message-Id: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
This patchset converts macros related to super_block into
functions. Besides that it fixes some sparse warnings (6th),
improves coding style (1st) and fixes error handling (4th).

Note that udf files has really long lines and these patches won't
validate by checkpatch. I'm going to do more cleanups later.

First version of this patchset had 24 patches: http://lkml.org/lkml/2007/12/22/150
01 didn't change
02 was dropped
03-17,20,21 was combined into one (with changes asked by Christoph Hellwig)
18 was slightly changed - function udf_sb_alloc_partition_maps was moved from udf_sb.h to super.c
19 didn't change
22,23 was combined into one and functions moved from udf_sb.h to super.c
24 didn't change

Marcin Slusarz
