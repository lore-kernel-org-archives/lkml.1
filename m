Return-Path: <linux-kernel-owner+w=401wt.eu-S1751331AbXBRPqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbXBRPqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 10:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXBRPqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 10:46:00 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:33515 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbXBRPqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 10:46:00 -0500
Date: Sun, 18 Feb 2007 16:45:58 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: securityfs_create_dir strange comment
Message-ID: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,


in security/inode.c, the comment for securityfs_create_dir() reads:

	If securityfs is not enabled in the kernel, the value -ENODEV 
	will be returned.  It is not wise to check for this value, but 
	rather, check for NULL or !NULL instead as to eliminate the need 
	for #ifdef in the calling code.

What is the actual callee that can return NULL - and what should 
module_init() of a module return when securityfs_create_dir() returns 
NULL?


Thanks,
Jan
-- 
