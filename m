Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbXIMNOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbXIMNOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXIMNOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:14:22 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:43614 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbXIMNOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:14:21 -0400
X-Greylist: delayed 2002 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 09:14:21 EDT
Date: Thu, 13 Sep 2007 15:13:53 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       video4linux-list@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Message-ID: <20070913131353.GB26972@linuxtv.org>
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota> <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com> <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 84.190.150.24
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007, Markus Rechberger wrote:
> Let's add the LKML to this.
> 
> On 9/13/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > On 9/12/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > I don't see any technical reason why tuner drivers should be moved to
> > > userspace. Looking at xc3028 device, the driver is very simple and
> > > doesn't require any special treatment that it isn't possible to be done
> > > at kernel. There are already some implementations on kernelspace that
> > > works fine.
> >
> > As from my side to support the xceive driver properly it needs a
> > rewrite and a proper API description. Since it's not possible to
> > discuss any API changes

Not possible? We're doing it all the time...

However, your ideas were rejected in this discussion,
and you can't seem to get over it.

> > don't get me wrong but the existing community is rather small and
> > kicking off people who are interested in changing things.

IMHO there is a lack of openness caused by people being burned
in past flamewars. This makes it a bit difficult to see through
what happens and why, and to participate.  However, I think it
is completely wrong to say that the community is "kicking off people".

> > I'm against how the project works out at the moment and how it worked
> > out in history. Exactly this way will kick off companies to be
> > interested in future like Avermedia. A driver can easily be written
> > within a few weeks and I've been struggling with it for 2 years(!!!)
> > now just for nothing finally telling me that some guys want to steal
> > my code and move it to kernelspace although it would raise more
> > complications with upcoming and current devices which have even more
> > requirements.

Oh dear, there we go again... more flame bait...

I reality, 95% of your driver code could have been merged
without problems, but you refused to take the small, objectionable
part out of the picture.

(For those interested:
http://mcentral.de/~mrec/patches/v4l-dvb/hg_v4l-dvb-experimental_01.patch
The patch changed the internal tuner API and required changes
to all tuner drivers.)

Your all-or-nothing approach didn't work out.

Out of curiosity: How does your userspace approach solve
the hybrid (analog/digital TV) tuner problem which was the
only objectionable part of your work? And why are the kernel
parts of your new interface now less objectionable? What changed?


Johannes
