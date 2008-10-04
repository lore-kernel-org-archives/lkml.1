Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYJDXnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYJDXnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 19:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYJDXnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 19:43:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:34765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYJDXnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 19:43:01 -0400
Date: Sat, 4 Oct 2008 16:42:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: add "personality" to process status file
Message-ID: <20081004164239.0c1483a4@infradead.org>
In-Reply-To: <20081004220220.GK10632@outflux.net>
References: <20081002211424.GJ10632@outflux.net>
	<20081004145149.52c34ee7@infradead.org>
	<20081004220220.GK10632@outflux.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 15:02:20 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> On Sat, Oct 04, 2008 at 02:51:49PM -0700, Arjan van de Ven wrote:
> > On Thu, 2 Oct 2008 14:14:24 -0700
> > Kees Cook <kees.cook@canonical.com> wrote:
> > 
> > > There is no sane way to query the personality flags of arbitrary
> > > process from userspace.  This adds the flags to
> > > the /proc/$pid/status file. For example, to detect
> > > READ_IMPLIES_EXEC:
> > > 
> > 
> > .. I'm sure local exploit writers will love this to find out which
> > processes to attack.
> > Realistically, this probably shouldn't be in a world-readable file.
> 
> Nothing else seemed appropriate, but I could make a brand new proc
> file, if that's sensible.  "status_private" ?

how about a file called "personality" that has each set bit as an ascii
version ?
(one per line maybe)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
