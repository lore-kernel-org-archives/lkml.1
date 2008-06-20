Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYFTWqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYFTWqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYFTWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:45:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56824 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYFTWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:45:57 -0400
Date: Fri, 20 Jun 2008 15:42:42 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] configfs: Fix failing symlink() making rmdir() fail
Message-ID: <20080620224242.GE21416@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080619221605.GE10888@mail.oracle.com> <1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
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

On Fri, Jun 20, 2008 at 02:09:22PM +0200, Louis Rilling wrote:
> What about this other solution? By the way, it does not even need to
> rename CONFIGFS_USET_IN_MKDIR.

	I like it.  My first thought was "why doesn't he take the mutex
during configfs_unlink()?", but the unlink is protected enough by
dirent_lock.

Joel

-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
