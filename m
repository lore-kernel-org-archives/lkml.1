Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbYFWWgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbYFWWgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYFWWgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:36:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59270 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYFWWgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:36:13 -0400
Date: Mon, 23 Jun 2008 15:34:50 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 0/5][BUGFIX] configfs: Fix deadlock of rename() vs
	rmdir()
Message-ID: <20080623223450.GH592@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080616170057.399713501@kerlabs.com> <20080616232657.GE6441@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616232657.GE6441@mail.oracle.com>
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

On Mon, Jun 16, 2008 at 04:26:57PM -0700, Joel Becker wrote:
> 	Ok, this is in-tree for the next merge.  Thanks.

	Btw, we still need to solve the lockdep issue.  I'm leaning
towards turning it off for attach/detach_groups(), because any CHILD+N
level won't mesh with the VFS anyway.
	We also need a comment on detach_group() pointing out its
recursive locking.  It's there in the code, but it's not obvious.

Joel

-- 

"Not everything that can be counted counts, and not everything
 that counts can be counted."
        - Albert Einstein 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
