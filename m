Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZIWOB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZIWOB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZIWOB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:01:28 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:32832 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZIWOB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <20090923115751.GA11820@infradead.org>
References: <20090921144308.GG8072@barkeeper1-xen.linbit> <20090921165252.04e335b1@infradead.org> 
	<20090921165321.GJ8072@barkeeper1-xen.linbit> <20090922072617U.fujita.tomonori@lab.ntt.co.jp> 
	<f73f7ab80909211751p4d797556lcce5e47c3241b5ef@mail.gmail.com> 
	<20090923115751.GA11820@infradead.org>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 23 Sep 2009 10:01:09 -0400
Message-ID: <f73f7ab80909230701k438be273y1e363a9ef5579e4d@mail.gmail.com>
Subject: Re: [GIT PULL] DRBD for 2.6.32
To: Christoph Hellwig <hch@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lars.ellenberg@linbit.com,
       arjan@infradead.org, lmb@suse.de, jens.axboe@oracle.com, neilb@suse.de,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       nab@linux-iscsi.org, knikanth@suse.de, philipp.reisner@linbit.com,
       sam@ravnborg.org, Mauelshagen@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 07:57, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Sep 21, 2009 at 08:51:32PM -0400, Kyle Moffett wrote:
>> You have to realize that this project is NOT a new one, it's been
>> around quite a decent number of years (since kernel 2.2-ish).  Yes,
>> the ABI is unique and has its warts, but there are a lot of things
>> that depend on it.
>
> So?  That's never been an argument.  Quite contrary, we ignored upstream
> for years and fucked up out of tree but please merge anyway is almost
> a counter-argument.

That's not what happened with DRBD at *all*.  It was a large project
that ignored upstream for a while yes... but recently they decided to
do things right and submitted all of their patches for review and
comments.  After a good number of review cycles during which they were
model citizens for making big necessary changes, nobody could find
anything technically wrong with the code.

Now people are asking the out-of-tree project to continue to maintain
their otherwise-perfectly-merge-ready patchset while also implementing
a bunch of MD/DM/RAID-integration code.  Meanwhile several of the
DM/MD RAID guys who *already* have their code upstream have not been
having much luck defining a usable userspace API for the proposed
integrated configuration model.

At the very least, the code is at the point where Greg KH could easily
merge it into staging:
  * The code is under GPLv2
  * The goal of the developers is to get it merged in the near future
  * It builds properly on x86
  * It's for a new feature (not an existing one)
  * There's a reliable point-of-contact for the code

The only thing missing is a list of exactly what still needs to be
fixed.  I see a lot of handwaving about "We want a new API", but
nobody defining what the requirements for that are.  If nobody can
figure that out yet, then I see no reason it shouldn't be mainline
mergeable; both Neil Brown and Jens Axboe seem to think this is ready
to merge as well.

Cheers,
Kyle Moffett
