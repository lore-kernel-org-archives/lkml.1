Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYDQShV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYDQShV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYDQShI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:37:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51197 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYDQShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:37:07 -0400
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20080417183642.2AC044C9B17@norville.austin.ibm.com>
Date: Thu, 17 Apr 2008 13:36:42 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

It's been kind of slow in JFS land, but I have a couple small cleanups I've
been carrying around.  Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_dmap.c  |   11 +++++------
 fs/jfs/jfs_dmap.h  |    2 +-
 fs/jfs/jfs_imap.c  |   15 ++++++---------
 fs/jfs/jfs_xtree.c |   26 ++++++++------------------
 4 files changed, 20 insertions(+), 34 deletions(-)

through these ChangeSets:

Commit: 15732a1cb5f9078d460a254449eb59391e531ffc 
Author: Harvey Harrison <harvey.harrison@gmail.com> Wed, 05 Mar 2008 14:38:22 -0600 

    jfs: replace __inline with inline
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 891456227881da9c565c455010380a40d385a478 
Author: Marcin Slusarz <marcin.slusarz@gmail.com> Wed, 13 Feb 2008 15:34:20 -0600 

    jfs: le*_add_cpu conversion
    
    replace all:
    little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
                                            expression_in_cpu_byteorder);
    with:
            leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
    generated with semantic patch
    
    Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Cc: jfs-discussion@lists.sourceforge.net

