Return-Path: <linux-kernel-owner+w=401wt.eu-S939077AbZDJS7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939077AbZDJS7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764998AbZDJS6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:58:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45376 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764739AbZDJS6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:58:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Fri, 10 Apr 2009 20:58:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl>
In-Reply-To: <200904101439.43480.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904102058.36018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009, Rafael J. Wysocki wrote:
> On Friday 10 April 2009, Linus Torvalds wrote:
> > 
> > On Fri, 10 Apr 2009, Rafael J. Wysocki wrote:
> > > 
> > > I'm seeing two problems with -git from today.
> > 
> > When today? A number of people apparently had module problems before 
> > commit 97c18e2c7a8e36d2d83d50ee070314aadac73a11 ("module: 
> > try_then_request_module must wait").
> > 
> > If you don't have that one, then that might explain both problems, in that 
> > a "second try" would work for modules (your sound issue), and that 
> > compiling things in would obviously avoid it (your storage driver thing).
> > 
> > But if you _do_ have that, then it's obviously something else ;)
> 
> Well, I do have that one. :-)

I've just verified that the resume-after-hibernation issue goes away after
reverting commit 9710794383ee5008d67f1a6613a4717bf6de47bc
(async: remove the temporary (2.6.29) "async is off by default" code) , so it
is async-related.

The audio issue still remains after the revert, so it is really different.

Thanks,
Rafael
