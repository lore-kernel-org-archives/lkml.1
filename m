Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZFZWNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZFZWNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZFZWNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:13:25 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:60977 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZFZWNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:13:24 -0400
Date: Sat, 27 Jun 2009 00:15:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Floris Kraak <randakar@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
Message-ID: <20090626221545.GE26451@uranus.ravnborg.org>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com> <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com> <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com> <20090614205002.GE3187@uranus.ravnborg.org> <Pine.LNX.4.64.0906150853320.23909@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906150853320.23909@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 08:54:02AM +0300, Pekka J Enberg wrote:
> From: Floris Kraak <randakar@gmail.com>
> 
> Some distributions have enabled the gcc flag -Wformat-security by default.
> This results in a number of warnings about format arguments to functions,
> sometimes in cases where fixing the warning is not likely to actually fix a
> bug.  Instead of hand patching a dozens of places (possibly more) that produce
> warnings that get ignored anyway we just turn off the flag in the Makefile.
> 
> Signed-off-by: Floris Kraak <randakar@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Applied.

	Sam
