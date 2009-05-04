Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZEDFkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZEDFkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 01:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZEDFkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 01:40:04 -0400
Received: from [212.69.161.110] ([212.69.161.110]:57987 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZEDFkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 01:40:03 -0400
Date: Mon, 4 May 2009 07:39:06 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Bart Van Assche <bart.vanassche@gmail.com>, linux-mm@kvack.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [v2] Generic LRU cache built on a kmem_cache and a "struct
	shrinker"
Message-ID: <20090504053905.GA6298@racke>
References: <f73f7ab80905032220w4aab3caal90703a253377e91c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f73f7ab80905032220w4aab3caal90703a253377e91c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 01:20:02AM -0400, Kyle Moffett wrote:
> On Sun, May 3, 2009 at 8:48 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
> > On Sun, May 3, 2009 at 6:48 PM, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> >> but wait for the next post to see a better documented (or possibly
> >> rewritten) implementation of this.
> >
> > Yeah, I'm definitely reworking it now that I have a better
> > understanding of what the DRBD code really wants.  My main intention
> > is to have the code be flexible enough that filesystems and other
> > sorts of network-related code can use it transparently, without
> > requiring much in the way of manual tuning.  See Linus' various
> > comments on why he *hates* manual tunables.

:)

> I'm heading to bed, but I figured I'd share what I've hacked up so
> far.  This new version hasn't even been remotely compile-tested yet,
> but it has most of the runtime-adjustable limits and tunables added.

> Lars, hopefully this is a little bit more usable for you?

I had my (as usual too short) sleep already,
and now it looks much closer to what we need,
partly because you changed them (thanks), and partly because
my focus area on the display now is slighly larger again ;)

hash table for the "get_by_label" still missing, I'll see
what I can do about that.

	Lars
