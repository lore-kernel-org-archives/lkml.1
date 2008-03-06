Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYCFBQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYCFBQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYCFBPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:15:01 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:47833 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbYCFBO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:14:59 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com, teigland@redhat.com
Subject: [PATCH 0/10] ocfs2: Userspace cluster stack support
Date: Wed,  5 Mar 2008 17:13:48 -0800
Message-Id: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches allow ocfs2 to use the distributed lock manager in fs/dlm
in conjunction with a userspace cluster stack.

This series builds on the stack-glue series sent previously.  It
provides a plug-in for userspace cluster stacks and fs/dlm.  Userspace
is responsible for communicating with the cluster stack and feeding
events through the ocfs2_control misc device.  ocfs2 is otherwise
agnostic, using the DLM for all of its interaction.

Using the new ocfs2_stack_user plug-in requires a development version of
the ocfs2 tools.  This version knows how to load the plug-in and
provides a daemon to interact with the cman cluster stack.

The second to last patch enables the plug-in in Kbuild.  The last patch
adds Kconfig options to select which ocfs2 cluster plug-ins get built.

The kernel code is also available on the 'stack-user' branch of my git
repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=stack-user
Pull:
git pull git://oss.oracle.com/git/jlbec/linux-2.6.git stack-user

The tools code is also available via git, in the 'stack-user' branch
as well.

View:
http://oss.oracle.com/git/?p=ocfs2-tools.git;a=shortlog;h=stack-user
Pull:
git pull git://oss.oracle.com/git/ocfs2-tools.git stack-user


