Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbZB0Ue1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbZB0Ue1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZB0UeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:34:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60572 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665AbZB0UeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:34:17 -0500
Subject: [RFC][PATCH] track files for checkpointability
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 27 Feb 2009 12:34:12 -0800
Message-Id: <20090227203412.BB254624@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This takes a suggestion of Ingo's along with comments from lots of
other people.  It can track whether a given file is able to be
checkpointed.  It has sane default assumptions for new filesystems
and introduces a f_op to allow easy overriding of behavior just
like the reset of the VFS.

You can also find these patches in git:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/daveh/linux-2.6-cr.git;a=shortlog;h=dave-v13.1
