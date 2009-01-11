Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZAKUuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZAKUuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZAKUuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:50:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:58828 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752204AbZAKUui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:50:38 -0500
X-Authenticated: #1490710
X-Provags-ID: V01U2FsdGVkX1+pPaENK32pZYX/m2MT94UV37t2VnqUcp3Q32bwD7
	ySTUGVrE3lNSJ7
Date: Sun, 11 Jan 2009 21:51:21 +0100 (CET)
From: Johannes Schindelin <Johannes.Schindelin@gmx.de>
X-X-Sender: schindelin@pacific.mpi-cbg.de
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: current git kernel has strange problems during bisect
In-Reply-To: <87tz85fuxr.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.00.0901112150110.3586@pacific.mpi-cbg.de>
References: <200901111602.53082.borntraeger@de.ibm.com> <200901111607.59054.borntraeger@de.ibm.com> <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de> <200901111620.03345.borntraeger@de.ibm.com> <alpine.LFD.2.00.0901111113150.6528@localhost.localdomain>
 <87tz85fuxr.fsf@basil.nowhere.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 11 Jan 2009, Andi Kleen wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> >
> > For bisect purposes, if you know you're not chasing down a btrfs issue, 
> > you can do
> >
> > 	git bisect good 34353029534a08e41cfb8be647d734b9ce9ebff8
> 
> Could you perhaps add some standard tag for that commit? That 
> would make it easier than to always find the exact btrfs commit.
> 
> Just an idea.

Well, AFAICT what Linus hinted at is that you do not need such a standard 
tag.  Indeed, you would only clutter the history with such tags, when it 
usually is just a matter of saying "git bisect good" whenever you _know_ 
you are hitting known-good history.

Ciao,
Dscho

