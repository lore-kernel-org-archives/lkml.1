Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYJ1V0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYJ1V0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYJ1V0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:26:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45603 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYJ1V0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:26:47 -0400
Date: Tue, 28 Oct 2008 14:26:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Karel Zak <kzak@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sfr@canb.auug.org.au
Subject: Re: [PATCH 2/2] documentation: split and build dnotify_test program
Message-Id: <20081028142602.c09213e7.randy.dunlap@oracle.com>
In-Reply-To: <20080819230454.GH2846@nb.net.home>
References: <20080817214456.e8c765fa.randy.dunlap@oracle.com>
	<20080819230454.GH2846@nb.net.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 01:04:54 +0200 Karel Zak wrote:

> On Sun, Aug 17, 2008 at 09:44:56PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Make dnotify_test.c source file and add it to Makefile so that
> > bitrot can be prevented.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  Documentation/filesystems/00-INDEX       |    2 +
> >  Documentation/filesystems/Makefile       |    2 -
> >  Documentation/filesystems/dnotify.txt    |   36 -------------------------------
> 
>  $ grep -c inotify Documentation/filesystems/dnotify.txt
>  0
> 
>  It would be nice to add a note that dnotify has been obsoleted by
>  inotify (>= 2.6.13).

Done for upcoming patch, but using "replaced by".

---
~Randy
