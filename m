Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbYASPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbYASPKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbYASPKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:10:33 -0500
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:56059 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757635AbYASPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:10:32 -0500
From: Justin Banks <justinb@bakbone.com>
Date: Sat, 19 Jan 2008 08:07:18 -0700
To: linux-kernel@vger.kernel.org
Subject: Where's the create() pointer?
Message-ID: <20080119150718.GA14765@bleen.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's probably been this way for a long time, and I'm just noticing, but
I can't seem to find the create() (among others) pointer for NFS filesystems.

Specifically, If I look at sb->s_root->d_inode->i_op there's no create
there. How do I find it? I'm guessing that the ability to share mount
structures between multiple NFS mounts resulted in some kind of fake
superblock, but I just can't figure out where to find the functions.

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
