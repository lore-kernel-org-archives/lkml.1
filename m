Return-Path: <linux-kernel-owner+w=401wt.eu-S965604AbXAXAtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965604AbXAXAtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965603AbXAXAts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:49:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45300 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965477AbXAXAtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:49:47 -0500
Date: Tue, 23 Jan 2007 16:49:44 -0800
From: Andrew Morton <akpm@osdl.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sed s/gawk/awk/ scripts/gen_init_ramfs.sh
Message-Id: <20070123164944.db8acbad.akpm@osdl.org>
In-Reply-To: <20070115221146.GA12698@uranus.ravnborg.org>
References: <200701151624.18033.rob@landley.net>
	<20070115221146.GA12698@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jan 2007 23:11:46 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Jan 15, 2007 at 04:24:17PM -0500, Rob Landley wrote:
> > Signed-off-by: Rob Landley <rob@landley.net>
> Acked-by: Sam Ravnborg <sam@ravnborg>
> 
> > Use "awk" instead of "gawk".
> > 
> > -- 
> > 
> > There's a symlink from awk to gawk if you're using the gnu tools, but no
> > symlink from gawk to awk if you're using BusyBox or some such.  (There's a
> > reason for the existence of standard names.  Can we use them please?)

If the kernel is being compiled on a non-Linux system (eg: legacy Unix)
then it is, I guess, possible for `awk' and `gawk' to offer different
features.  If the kernel's use of gawk uses GNU extensions then this patch
might break things on such a system.

I guess we'll find out...
