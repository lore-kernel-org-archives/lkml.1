Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYAAKdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYAAKdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYAAKdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:33:43 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40614 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYAAKdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:33:42 -0500
Date: Tue, 1 Jan 2008 11:33:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch 1/8] UML: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101103342.GH28913@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101071846.GB2496@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071846.GB2496@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:18:46PM +0800, WANG Cong wrote:
> 
> TOPDIR is obsolete, use objtree instead.
> This patch removes TOPDIR from all UML Makefiles.
> 

I do not feel confident with these changes.
In some places I had expected to see srctree and not objtree.
I would like to see this tested before applying it.

Building a ppc toolchain now to test it...

	Sam
