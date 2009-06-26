Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbZFZS4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbZFZS4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZFZS4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:56:07 -0400
Received: from mailhost18.gawab.com ([66.220.20.18]:51701 "HELO
	info3.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752169AbZFZS4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:56:06 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/15] drbd: a block device for HA clusters
Date: Fri, 26 Jun 2009 21:42:30 +0300
User-Agent: KMail/1.5
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1246017715-9821-1-git-send-email-philipp.reisner@linbit.com> <200906261843.59635.a1426z@gawab.com> <1246032541.3925.53.camel@mulgrave.site>
In-Reply-To: <1246032541.3925.53.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906262142.30895.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-06-26 at 18:43 +0300, Al Boldi wrote:
> > James Bottomley wrote:
> > > On Fri, 2009-06-26 at 17:15 +0300, Al Boldi wrote:
> > > > Philipp Reisner wrote:
> > > > > Short Description
> > > > >
> > > > >   DRBD is a shared-nothing, synchronously replicated block device.
> > > >
> > > > What do you mean by "shared-nothing"?
> > >
> > > If you actually type "shared nothing" into google, the first hit will
> > > be the wikipedia article describing this.
> >
> > Sure, but the point here is to choose a description that is clear and
> > self-explanatory, and "shared-nothing" is neither clear nor
> > self-explanatory.
>
> It is clear because everyone agrees on the definition.

Everyone involved in the project maybe, but not everyone interested in "a 
block device for HA clusters".  And you don't want to turn them of by using 
terminology to explain terminology, especially when it's misleading.  Many 
OpenSource projects fail merely for this reason.

> And it is self
> explanatory because it's an art term for a well defined concept which
> forms one of the building blocks of the nomenclature used in clustering.
> Even if you're not familiar with clustering terminology, the definitions
> are easy to find via search engines.
>
> If you want to find useful quibbles, the term synchronously is wrong:
> DRBD is capable of both synchronous and asynchronous replication.

Ok, so maybe change the description to reflect this capability.
Something like:  DRBD is an independent, synch/async replicated block device.


Thanks!

--
Al

