Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbXJYOrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbXJYOrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbXJYOr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:47:26 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:38040 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbXJYOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:47:25 -0400
Date: Thu, 25 Oct 2007 15:47:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [IDE] Fix build bug
In-Reply-To: <20071025141305.GA11698@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64N.0710251545300.24086@blysk.ds.pg.gda.pl>
References: <20071025135334.GA23272@linux-mips.org> <20071025141305.GA11698@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Sam Ravnborg wrote:

> So we can avoid this if we invent a __constinitdata tag that uses
> a new section?

 That would do.

> I ask mainly to understand this error - not that I am that found
> of the idea.

 Somebody wants to mix up read-only and read/write data in the same 
section and GCC quite legitimately complains about it.  You cannot have 
both at a time.

  Maciej
