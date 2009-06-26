Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbZFZQJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbZFZQJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759015AbZFZQJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:09:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44698 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbZFZQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:09:04 -0400
Subject: Re: [PATCH 00/15] drbd: a block device for HA clusters
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Boldi <a1426z@gawab.com>
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
In-Reply-To: <200906261843.59635.a1426z@gawab.com>
References: <1246017715-9821-1-git-send-email-philipp.reisner@linbit.com>
	 <200906261715.40545.a1426z@gawab.com>
	 <1246026335.3925.16.camel@mulgrave.site>
	 <200906261843.59635.a1426z@gawab.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 16:09:01 +0000
Message-Id: <1246032541.3925.53.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 18:43 +0300, Al Boldi wrote:
> James Bottomley wrote:
> > On Fri, 2009-06-26 at 17:15 +0300, Al Boldi wrote:
> > > Philipp Reisner wrote:
> > > > Short Description
> > > >
> > > >   DRBD is a shared-nothing, synchronously replicated block device.
> > >
> > > What do you mean by "shared-nothing"?
> >
> > If you actually type "shared nothing" into google, the first hit will be
> > the wikipedia article describing this.
> 
> Sure, but the point here is to choose a description that is clear and 
> self-explanatory, and "shared-nothing" is neither clear nor self-explanatory.

It is clear because everyone agrees on the definition.  And it is self
explanatory because it's an art term for a well defined concept which
forms one of the building blocks of the nomenclature used in clustering.
Even if you're not familiar with clustering terminology, the definitions
are easy to find via search engines.

If you want to find useful quibbles, the term synchronously is wrong:
DRBD is capable of both synchronous and asynchronous replication.

James


