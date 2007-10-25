Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbXJYQF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbXJYQF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXJYQFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:05:45 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:43103 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXJYQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:05:44 -0400
Date: Thu, 25 Oct 2007 17:05:29 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [IDE] Fix build bug
Message-ID: <20071025160529.GB24621@linux-mips.org>
References: <20071025135334.GA23272@linux-mips.org> <20071025141305.GA11698@uranus.ravnborg.org> <Pine.LNX.4.64N.0710251545300.24086@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0710251545300.24086@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 03:47:16PM +0100, Maciej W. Rozycki wrote:

> > So we can avoid this if we invent a __constinitdata tag that uses
> > a new section?
> 
>  That would do.
> 
> > I ask mainly to understand this error - not that I am that found
> > of the idea.
> 
>  Somebody wants to mix up read-only and read/write data in the same 
> section and GCC quite legitimately complains about it.  You cannot have 
> both at a time.

My interpretation is that it would be perfectly ok for a C compiler to
do minimal handling of const by only throwing errors for attempted
assignments to const objects but otherwise treating them as if they
were non-const, that is for example putting them into an r/w section.

  Ralf
