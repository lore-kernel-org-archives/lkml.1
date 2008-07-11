Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbYGKWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbYGKWIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYGKWIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:08:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63500 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbYGKWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:08:14 -0400
Date: Fri, 11 Jul 2008 15:07:40 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
	failure
Message-ID: <20080711220740.GC22577@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
> This patchset fixes two kinds of bugs happening when
> configfs_attach_group()/configfs_attach_item() fail and userspace races with
> mkdir() or symlink().

	Ok, I've merged all this work.  Please check out my configfs-ALL
branch and make sure I have everything we've worked on.

http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=configfs-ALL
git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
