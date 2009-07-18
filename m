Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZGRHGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZGRHGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932323AbZGRHGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:06:45 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46158 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbZGRHGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:06:44 -0400
Date: Sat, 18 Jul 2009 09:06:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dick Streefland <dick@streefland.net>, Randy Dunlap <rdunlap@xenotime.net>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090718070643.GA7703@merkur.ravnborg.org>
References: <20090624114607.GA10817@streefland.net> <20090624133148.GA12878@streefland.net> <20090629025146.GA5998@cr0.nay.redhat.com> <20090629113613.GA6853@streefland.net> <20090709023855.GA5648@cr0.nay.redhat.com> <20090709082651.GA6165@streefland.net> <20090710075530.GB6263@cr0.nay.redhat.com> <20090710095432.GA9721@streefland.net> <20090717211703.GF7080@merkur.ravnborg.org> <20090717230859.GB10171@streefland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717230859.GB10171@streefland.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 01:08:59AM +0200, Dick Streefland wrote:
> On Friday 2009-07-17 23:17, Sam Ravnborg wrote:
> | Dick - I lost the original patch.
> | Can you please resend.
> | 
> | In the changelog please include the information that
> | you tested this with relevant grep versions.
> 
> Sure, here it is:
> 
> ======================================================================
> 
> I've rewritten the extract-ikconfig script to extract the kernel
> configuration from a kernel compiled with CONFIG_IKCONFIG. The main
> motivation for the rewrite was to remove the dependency on the
> external C program binoffset.c, which is compiled on the initial run.
> 
> The binoffset executable is invoked with a relative path, which means
> that the old script can only be run from the top of the kernel tree,
> and only when you have write permission in the scripts directory.
> The new script uses tr/grep/tail/zcat only, and can be invoked from
> anywhere. The binoffset.c program has been removed. This script
> requires GNU grep 2.5 (released 2002-03-13) or higher, because the -o
> option was introduced in that version.
> 
> Signed-off-by: Dick Streefland <dick@streefland.net>

Applied to kbuild-next.git.

	Sam
