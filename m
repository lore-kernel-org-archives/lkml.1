Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYAFBU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYAFBU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYAFBUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:20:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYAFBUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:20:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=nonLgUpfO9A/BhcSkYeYtu8nqsNPJtg3w+iWgLqKef+QSa0RKXa4dSE7QESIDXAe41UAMbKDgbfVGvpfO3mx8DMs4hDAQlCDLs/L7su0aQGHrfEyiegeElCmJyLdNJcMs0pQfZMuDEUF6urXJ3ZiBn/X9OH8DOcyWGFAiC/kWMo=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 0/7] udf: more cleanups
Date: Sun,  6 Jan 2008 02:21:47 +0100
Message-Id: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patchset contains various UDF fs cleanups.

[PATCH 1/7] udf: fix coding style
This is really big (~170kB) and boring (style cleanup) patch,
so I'm not sending it to LKML. You can find it here:
http://www.kadu.net/~joi/kernel/2008.01.06/0001-udf-fix-coding-style.patch

[PATCH 2/7] udf: create common function for tag checksumming
[PATCH 3/7] udf: create common function for changing free space counter
[PATCH 4/7] udf: replace loops coded with goto to real loops
[PATCH 5/7] udf: convert byte order of constant instead of variable

[PATCH 6/7] udf: remove UDF_I_* macros and open code them
This is preparation for 7th patch.

[PATCH 7/7] udf: cache struct udf_inode_info

Patchset depends on udf patches in -mm and this: http://lkml.org/lkml/2008/1/5/196

(Runtime tested: mount, open, read, seek, close, umount)

Marcin Slusarz
