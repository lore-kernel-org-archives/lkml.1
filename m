Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXJOP1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXJOP1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXJOP1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:27:13 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:47560 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXJOP1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:27:13 -0400
Date: Mon, 15 Oct 2007 16:27:03 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: Remove duplicate output of .exit.data
In-Reply-To: <21428.1192267071@redhat.com>
Message-ID: <Pine.LNX.4.64N.0710151624140.16262@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0710121633480.21684@blysk.ds.pg.gda.pl>
 <21428.1192267071@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, David Howells wrote:

> >  When CONFIG_DEBUG_INFO is unset the input .exit.data sections are copied 
> > twice to vmlinux.  Remove the copy made to .init.text and keep one in 
> > .data only.
> 
> No, they aren't.  I believe the linker only makes one copy of each section,
> and once a copy is inserted, all other attempts to make a copy of it are
> ignored.

 Fair enough -- a quick test shows you are right.  Wouldn't it deserve a 
comment, though?  I know hardly anybody dares looking into these scripts, 
;-) but those who do, may not be sure this setup is intentional.

  Maciej
