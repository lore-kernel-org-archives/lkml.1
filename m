Return-Path: <linux-kernel-owner+w=401wt.eu-S2993291AbXDTRrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993291AbXDTRrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993299AbXDTRrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:47:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993291AbXDTRrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:47:20 -0400
Message-ID: <4628FC9E.9080503@redhat.com>
Date: Fri, 20 Apr 2007 13:47:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: reiserfs-dev@namesys.com
Subject: 4K stack overflow with nfs3, reiserfs, dm and raid1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

4K stacks still overflow:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=237276

Just trying to dump the stack trace when that happens causes an oops,
and there's no good way to prevent that. In fact it's probably the
best thing to do anyway.

You can tell something Really Bad has happened because of this:

> Process nfsd (pid: 2815, ti=f3f49000 task=f582d7b0 task.ti=f3f4a000)

Note that ti and task.ti don't agree.

P. S. Does reiserfs really need to use that much stack?
