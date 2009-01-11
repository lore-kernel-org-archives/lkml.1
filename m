Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZAKPNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZAKPNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZAKPNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:13:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:38639 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751848AbZAKPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:13:19 -0500
X-Authenticated: #1490710
X-Provags-ID: V01U2FsdGVkX18PiYxAkJMPEfppsRwL9gWgM7WdcBnRGe5pGLuAUF
	D7kLs1JibzEhZ+
Date: Sun, 11 Jan 2009 16:14:03 +0100 (CET)
From: Johannes Schindelin <Johannes.Schindelin@gmx.de>
X-X-Sender: schindelin@pacific.mpi-cbg.de
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: current git kernel has strange problems during bisect
In-Reply-To: <200901111607.59054.borntraeger@de.ibm.com>
Message-ID: <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de>
References: <200901111602.53082.borntraeger@de.ibm.com> <200901111607.59054.borntraeger@de.ibm.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 11 Jan 2009, Christian Borntraeger wrote:

> Am Sonntag 11 Januar 2009 schrieb Christian Borntraeger:
> > doing a 
> > git bisect start
> > git bisect good a3a798c
> > git bisect bad v2.6.29-rc1
> > 
> > results in a repository without several files, e.g Makefile!
> > git describe also fails.
> 
> In fact, retesting with a clean repository shows, that there are only btrfs 
> files - nothing else.
> 
> Linus did you pull a broken btrfs repository?

I guess it is a subtree merge.  So no, nothing went wrong

Use "git bisect skip" to skip over those.

Hth,
Dscho

