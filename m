Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZEHXoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZEHXoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZEHXn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:43:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZEHXnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:43:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Sat, 9 May 2009 01:43:10 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905090046.21282.rjw@sisk.pl> <1241825408.19600.384.camel@nigel-laptop>
In-Reply-To: <1241825408.19600.384.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905090143.10980.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2009-05-09 at 00:46 +0200, Rafael J. Wysocki wrote:
> > On Friday 08 May 2009, Nigel Cunningham wrote:
> > > On Fri, 2009-05-08 at 16:11 +0200, Rafael J. Wysocki wrote:
> > > > On Friday 08 May 2009, Nigel Cunningham wrote:
> > > > > On Thu, 2009-05-07 at 23:51 +0200, Pavel Machek wrote:
> > > > > > On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> > > > > > > On Thursday 07 May 2009, Pavel Machek wrote:
[--snip--]
> > > And the code includes some fundamental differences. I freeze processes
> > > and prepare the whole image before saving anything or doing an atomic
> > > copy whereas you just free memory before doing the atomic copy. You save
> > > everything in one part whereas I save the image in two parts.
> > 
> > IMO the differences are not that fundamental.  The whole problem boils down
> > to using the same data structures for memory management and I think we can
> > reach an agreement here.
> 
> I think we might be able to agree on using the same data structures, but
> I'm not so sure about algorithms - I think you're underestimating the
> differences here.

Well, which algorithms do you have in mind in particular?

Rafael
