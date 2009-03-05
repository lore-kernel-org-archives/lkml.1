Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZCEQkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZCEQkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZCEQjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:16 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56231 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZCEQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:15 -0500
Subject: [RFC][PATCH 00/11] track files for checkpointability
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:38:57 -0800
Message-Id: <20090305163857.0C18F3FD@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This takes a suggestion of Ingo's along with comments from lots of
other people.  It can track whether a given file is able to be
checkpointed.  It introduces a f_op to allow easy customization
like the reset of the VFS.

You can also find these patches in git:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/daveh/linux-2.6-cr.git;a=shortlog;h=dave-v13.4

Sorry if anybody got this twice.  I'm fighting with git-send-email.
