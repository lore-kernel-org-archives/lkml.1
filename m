Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbZATP1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbZATP1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZATP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:27:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:37578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbZATP1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:27:34 -0500
Subject: usr/include/linux/reiserfs_fs.h is having lot of KERNEL data
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: reiserfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 20:57:22 +0530
Message-Id: <1232465242.3088.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usr/include/linux/reiserfs_fs.h is giving 21 'make headers_clean' warnings:
 usr/include/linux/reiserfs_fs.h:64: leaks CONFIG_REISERFS to userspace where it is not valid
 usr/include/linux/reiserfs_fs.h:81: leaks CONFIG_REISERFS to userspace where it is not valid
 usr/include/linux/reiserfs_fs.h:687: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:995: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:997: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1467: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1587: leaks CONFIG_QUOTA to userspace where it is not valid
 usr/include/linux/reiserfs_fs.h:1760: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1764: extern's make no sense in userspace 
 usr/include/linux/reiserfs_fs.h:1766: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1769: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1771: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1805: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1908: leaks CONFIG_PROC to userspace where it is not valid
 usr/include/linux/reiserfs_fs.h:1948: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1949: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1950: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1951: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1962: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1963: extern's make no sense in userspace
 usr/include/linux/reiserfs_fs.h:1964: extern's make no sense in userspace

This file is huge and need lot of cleanup.

Anyone interested to fix this file.

Thanks,

--
JSR

