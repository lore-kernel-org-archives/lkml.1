Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXHDWGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXHDWGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762841AbXHDWGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:06:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50314 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761515AbXHDWGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:06:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc2
Date: Sun, 5 Aug 2007 00:15:35 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org> <200708041230.51074.rjw@sisk.pl>
In-Reply-To: <200708041230.51074.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708050015.36217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 August 2007 12:30, Rafael J. Wysocki wrote:
> On Saturday, 4 August 2007 05:50, Linus Torvalds wrote:
> > 
> > So I tried to hold people to the merge window, and said no to a few pull 
> > requests, but this whole "-rc2 is the new -rc1" thing is a disease, and 
> > not only is -rc2 late, it's bigger than it should be. Oh, well.
> 
> Suspend and hibernation are busted on SMP x86_64, AFAICS.  My test boxes
> don't resume.
> 
> 2.6.23-rc1 and 2.6.23-rc1-mm2 both work just fine on the same machines, so
> this has to be due to a recent change.  I'll bisect later today.

Well, fortunately there's nothing wrong with 2.6.23-rc2 in this respect and it
was my own patch that busted suspend and hibernation for me.  Specifically,
this one: http://lkml.org/lkml/2007/8/4/29 .

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
