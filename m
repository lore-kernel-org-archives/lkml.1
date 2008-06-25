Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYFYUbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYFYUbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYFYUav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:30:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34779 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYFYUau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:30:50 -0400
Date: Wed, 25 Jun 2008 13:29:14 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: configfs: Q: item leak in a failing configfs_attach_group()?
Message-ID: <20080625202914.GD14049@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080624141649.GH7621@hawkmoon.kerlabs.com> <20080624171051.GD4184@ca-server1.us.oracle.com> <20080624180456.GA32036@hawkmoon.kerlabs.com> <20080624213439.GB2785@mail.oracle.com> <20080625095527.GB32036@hawkmoon.kerlabs.com> <20080625202058.GC14049@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625202058.GC14049@ca-server1.us.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 01:20:58PM -0700, Joel Becker wrote:
> 	Um, 'A' hasn't appeared yet.  I don't see how it looks up 'A'
> until we're done.

	Oh, I think you mean cached_lookup isn't blocked by i_mutex.

Joel

-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
