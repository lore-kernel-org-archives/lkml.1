Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYDXVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYDXVMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYDXVLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:11:55 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15843 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYDXVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:11:54 -0400
Date: Thu, 24 Apr 2008 14:11:24 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 14/15] m68k: Update defconfigs
Message-ID: <20080424211124.GD2131@mail.oracle.com>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080424182940.424312704@mail.of.borg> <20080424183243.884021921@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424183243.884021921@mail.of.borg>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 08:29:54PM +0200, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Update the m68k defconfigs

<snip>

>  CONFIG_OCFS2_FS=m
> +# CONFIG_OCFS2_FS_O2CB is not set
> +# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
>  # CONFIG_OCFS2_DEBUG_MASKLOG is not set
>  # CONFIG_OCFS2_DEBUG_FS is not set

	In these defconfigs, you disable the cluster stack drivers for
ocfs2.  This means that ocfs2 can only work as a local filesystem.
While it will work fine that way, I figured I'd send an email in case
that wasn't your intention :-)  I note that the following
multi_defconfig has the cluster stack drivers enabled:

+CONFIG_OCFS2_FS=m
+CONFIG_OCFS2_FS_O2CB=m
+CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m

Joel

-- 

"The one important thing i have learned over the years is the
 difference between taking one's work seriously and taking one's self
 seriously.  The first is imperative and the second is disastrous."
	-Margot Fonteyn

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
