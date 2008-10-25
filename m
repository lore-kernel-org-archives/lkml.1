Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYJYLNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYJYLNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYJYLN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:13:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbYJYLN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:13:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: oops while booting with recent git kernel
Date: Sat, 25 Oct 2008 13:18:15 +0200
User-Agent: KMail/1.9.9
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200810121227.09114.a.miskiewicz@gmail.com> <200810250029.35880.rjw@sisk.pl> <86802c440810241719l3e045a8fl33fd5f348857324e@mail.gmail.com>
In-Reply-To: <86802c440810241719l3e045a8fl33fd5f348857324e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810251318.15743.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 of October 2008, Yinghai Lu wrote:
> On Fri, Oct 24, 2008 at 3:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, 14 of October 2008, Vegard Nossum wrote:
> >> On Sun, Oct 12, 2008 at 12:27 PM, Arkadiusz Miskiewicz
> >> <a.miskiewicz@gmail.com> wrote:
> >> >
> >> > Not sure if it's worth to report this before all initial merges happen but
> >> > here it is anyway.
> >> >
> >> > git kernel with latest commit:
> >> > commit fd048088306656824958e7783ffcee27e241b361
> >> > Date:   Sat Oct 11 13:23:48 2008 -0700
> >> >
> >> > booted on thinkpad z60m results with such oops:
> >> > http://carme.pld-linux.org/~arekm/img_2325_small.png
> >> >
> >> > Config used:
> >> > http://carme.pld-linux.org/~arekm/img_2325_small.config
> >>
> >> Thanks for the report.
> >>
> >> It seems to be an instance of this (known bad) code:
> >> http://lkml.org/lkml/2008/9/4/386
> >>
> >> So hopefully it will be fixed soon.
> >
> > Has it been fixed, actually?
> 
> should be fixed by in upstream.. already

OK, thanks.
