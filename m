Return-Path: <linux-kernel-owner+w=401wt.eu-S1764530AbZDHVKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764530AbZDHVKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbZDHVK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:10:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbZDHVKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:10:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] x86: unify power/cpu_(32|64).c
Date: Wed, 8 Apr 2009 23:10:19 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Sergio Luis <sergio@larces.uece.br>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Lauro Salmito <laurosalmito@gmail.com>,
       x86 Maintainers <x86@kernel.org>
References: <49D71EEE.30600@larces.uece.br> <200904042304.25088.rjw@sisk.pl> <20090408123413.GF18581@elte.hu>
In-Reply-To: <20090408123413.GF18581@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904082310.19870.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Monday 30 March 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > x86: unify power/cpu_(32|64).c
> > > > 
> > > > This is the last unification step. Here we do remove one of the files
> > > > and rename the left one as cpu.c, as both are now the same.
> > > > Also update power/Makefile, telling it to build cpu.o, instead of
> > > > cpu_(32|64).o
> > > > 
> > > > Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> > > > Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
> > > 
> > > 
> > > Whole series looks ok to me.
> > > 
> > > Acked-by: Pavel Machek <pavel@ucw.cz>
> > 
> > However, there's no way it can go in before 2.6.30 final.
> 
> Correct.
> 
> > I'm reviewing it at the moment.
> 
> Feel free to queue these bits up in your tree - it's largely related 
> to your area anyway.

I will, thanks.

> That way you can stage it in the most robust way. You have a stable
> (append-only) Git tree for suspend/resume bits, which propagates into
> linux-next, correct?

Yes, I do.

Best,
Rafael
