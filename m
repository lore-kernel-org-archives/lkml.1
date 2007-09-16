Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbXIPTZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbXIPTZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXIPTZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:25:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbXIPTZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:25:35 -0400
Date: Sun, 16 Sep 2007 12:23:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild update
Message-Id: <20070916122343.59e8885d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709160856060.20489@localhost.localdomain>
References: <20070916094739.GA6672@uranus.ravnborg.org>
	<Pine.LNX.4.64.0709160856060.20489@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007 08:58:03 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> On Sun, 16 Sep 2007, Sam Ravnborg wrote:
> 
> > A summary of what is planned to be submitted in next merge window for kbuild.
> > The shortlog below have additional details but the headlines are:
> ...
> > o add script to find unused kconfig symbols (try it!)
> 
> based on my experiences with this, unless you filter carefully, you're
> going to end up with a *whack* of false positives given the number of
> developers who elect to name their local macros starting with a prefix
> of "CONFIG_".  good luck dealing with *that*.  :-)

box:/usr/src/linux-2.6.23-rc6> grep -r '^[      ]*#[    ]*define[       ]*CONFIG_' . | wc -l
415

bah.  They're all bugs - The CONFIG_foo namespace is (should be) reserved in
kernel coding.


