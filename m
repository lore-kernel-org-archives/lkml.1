Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646Ab0ATMwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0ATMwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922Ab0ATMwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:52:33 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:62309 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab0ATMwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:52:33 -0500
Date: Wed, 20 Jan 2010 13:52:49 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, hch@infradead.org, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Obsolete config in kernel build system (XFS_TRACE)
Message-ID: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	Git commit 0b1b213fcf3a8486ada99a2bab84ab8c6f51b264 by
Christoph Hellwig removed all References to CONFIG_XFS_TRACE, which is
unreferenced from KConfig side from the linux source code so there's
only a small bit of it left in KBuild. Mayee remove it as well?

./fs/xfs/Makefile:95
+++>

xfs-$(CONFIG_XFS_TRACE)         += xfs_btree_trace.o

<+++

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

