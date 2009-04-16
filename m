Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZDPFmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZDPFmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZDPFmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:42:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34435 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZDPFmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:42:07 -0400
Date: Thu, 16 Apr 2009 06:42:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/genhd.c: fix sparse warning
Message-ID: <20090416054205.GX26366@ZenIV.linux.org.uk>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFA@mi8nycmail19.Mi8.com> <19f34abd0904152146l3db9961bt3b52f224abc8d960@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0904152146l3db9961bt3b52f224abc8d960@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 06:46:32AM +0200, Vegard Nossum wrote:
> 2009/4/16 H Hartley Sweeten <hartleys@visionengravers.com>:
> > Fix sparse warning in block/genhd.c.
> >
> > ?? ?? ?? ??warning: symbol '__mptr' shadows an earlier one
> >
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> Hi,
> 
> Just a heads up: There seems to be some sort of consensus that this
> type of patch title is not a very good one. (What about "remove
> variable shadowing"?)

Indeed.  Speaking of other kind of unpleasantness, could you please
configure your mail-luser-agent to *NOT* replace tabs with series
of spaces/nbsp?  That crap is very annoying - these strings of
U+00A0 U+00A0 U+00A0 et sodding cetera are gratuitously making life
painful for non-UTF8 terminals.
