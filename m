Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZGIRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZGIRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZGIRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:09:19 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:54076 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752229AbZGIRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:09:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=B3pdcYmamn8CEM1A3Bz1bo5qDL5YJCBNaFccQ6rHDYh7BbnV695slOZq7acl86DEC3nZh1A2IFNkzgHRs5QDJKH9z+ljPIMeXelkr8Lr19cIsB7B40I6o518zZzxADel;
Date: Thu, 9 Jul 2009 10:09:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Frans Pop <elendil@planet.nl>
Cc: Dave Airlie <airlied@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
Message-ID: <20090709100914.2502763a@jbarnes-g45>
In-Reply-To: <200907090328.53643.elendil@planet.nl>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	<200907080700.33120.elendil@planet.nl>
	<21d7e9970907081642l3ef6df5blde31df656cd74432@mail.gmail.com>
	<200907090328.53643.elendil@planet.nl>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009 03:28:52 +0200
Frans Pop <elendil@planet.nl> wrote:

> On Thursday 09 July 2009, Dave Airlie wrote:
> > > [1] I'd even go so far as to feel it should be a standard test
> > > case for video driver developers, given that this is the third
> > > time it's shown regressions :-) For the third case the bug was in
> > > the X.Org i830 driver:
> > > http://bugs.freedesktop.org/show_bug.cgi?id=14481.
> >
> > It might surprise you to learn this, but vesafb has never been
> > considered supportable by the X.org community, and you'll notice not
> > very many distros ship with it enabled, it breaks suspend/resume on
> > many machines for example.
> 
> I beg to disagree.
> - Debian does have it enabled by default.
> - I have always used it on all my machines without any problems.
> - Both my laptops and my desktop suspend and resume perfectly with
> vesafb and X.Org.
> - Jesse Barnes seems to disagree with you. To quote from the BR cited
>   above (comment #11): "and you're right, making things work with
> vesafb isn't unreasonable".

Since my ears are burning I figured I'd better qualify this: I made
that statement before we had KMS upstream.  Supporting the case where
multiple drivers try to bang on the same device has always been a big
pain.  In a KMS configuration we don't support it at all.

> Yes, and I really welcome the great progress being made there. But
> for me it's not yet an option as I run Debian stable on these boxes.

Sounds like that's not an option for you though... which means
debugging where the interaction is going wrong...

Jesse
