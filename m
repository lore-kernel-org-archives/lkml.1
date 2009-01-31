Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZAaUK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZAaUK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 15:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZAaUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 15:10:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbZAaUKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 15:10:47 -0500
Date: Sat, 31 Jan 2009 12:10:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-01-31-01-08 uploaded (staging vs. mach64:
 CONFIG_PANEL)
Message-Id: <20090131121008.eb7f5ddd.akpm@linux-foundation.org>
In-Reply-To: <4984AC40.8030708@oracle.com>
References: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
	<4984AC40.8030708@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 11:53:36 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-01-31-01-08 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> drivers/staging/panel/Kconfig: config PANEL
> vs. include/video/mach64.h: #define CONFIG_PANEL	0x00
> 
> 
> When staging's CONFIG_PANEL=y (is enabled), the mach64.h header file gets
> lots of these:
> 
> include/video/mach64.h:1257:1: warning: "CONFIG_PANEL" redefined
> 
> 
> so staging adds a new config symbol that conflicts with the
> (incorrect namespace) usage in mach64.h.
> 
> mach64 needs to change IMO, even though it is older.

Sigh, yes, that file has gone on a rampage through the namespace
rules.  I'll take a look at it sometime.
