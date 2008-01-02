Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYABJwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYABJwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYABJv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:51:59 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47734 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbYABJv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:51:58 -0500
Date: Wed, 2 Jan 2008 10:51:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch 0/8] Remove 'TOPDIR' from Makefiles
Message-ID: <20080102095159.GB7815@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:13:11PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use srctree or objtree instead.
> 
> This patch set removes all the TOPDIR use in the whole
> source tree and finally drops it in the top Makefile.
> They're against the current linus-tree.
> 
> Note that Patch [8/8] should be applied _after_ all the
> previous patches are applied.

Hi Wang.

You a heads up. I will most likely apply
the remaining of the patches tonight, except the UM stuff
which I hope Jeff to take and the final removal of TOPDIR
may wait a bit.
I want the s390, xfs and um changes to hit -mm at least
and we have several external modules that uses TOPDIR.

And some of these external modules I care about - not
all of them but some of them.

	Sam
