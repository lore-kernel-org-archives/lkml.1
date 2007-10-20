Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbXJTHzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbXJTHzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 03:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXJTHyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 03:54:55 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:46016 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbXJTHyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 03:54:54 -0400
Date: Sat, 20 Oct 2007 03:54:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roel Kluin <12o3l@tiscali.nl>
cc: Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] RT: Only dirty a cacheline if the priority is actually
 changing
In-Reply-To: <47196C9B.7090909@tiscali.nl>
Message-ID: <Pine.LNX.4.58.0710200353270.12737@gandalf.stny.rr.com>
References: <20071017184745.11272.10024.stgit@novell1.haskins.net>
 <20071017185113.11272.50568.stgit@novell1.haskins.net> <47196C9B.7090909@tiscali.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Sat, 20 Oct 2007, Roel Kluin wrote:

> Gregory Haskins wrote:
> > We can avoid dirtying a rq related cacheline with a simple check, so why not.
> >
> > Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> > ---
> >
> >  0 files changed, 0 insertions(+), 0 deletions(-)
>
> I think you wanted a patch here?
>

But it is here.  Gregory is a Zen master, and this patch does exactly what
he wanted it to do.

-- Steve

