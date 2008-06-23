Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYFWWZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYFWWZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYFWWZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:25:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22069 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYFWWZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:25:43 -0400
Date: Mon, 23 Jun 2008 15:20:44 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 0/2]v2 configfs: symlink() fixes
Message-ID: <20080623222043.GG592@mail.oracle.com>
Mail-Followup-To: Louis Rilling <louis.rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214223378-14203-1-git-send-email-louis.rilling@kerlabs.com>
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

On Mon, Jun 23, 2008 at 02:16:16PM +0200, Louis Rilling wrote:
> The following patchset fixes incorrect symlinks to dead items in configfs, which
> are forbidden by specification.
> 
> The first patch actually prevents such dangling symlinks from being created, but
> introduces a weird(?) behavior where a failing symlink() can make a racing
> rmdir() fail in the symlink's parent and in the symlink's target as well. This
> behavior is fixed with the next patch.

	Silly question: you've tested this, right?

Joel

-- 

"I almost ran over an angel
 He had a nice big fat cigar.
 'In a sense,' he said, 'You're alone here
 So if you jump, you'd best jump far.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
