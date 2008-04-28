Return-Path: <linux-kernel-owner+w=401wt.eu-S937368AbYD1TmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937368AbYD1TmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765693AbYD1TmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:42:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765614AbYD1TmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:42:00 -0400
Subject: Re: stat benchmark
From: Alexander Larsson <alexl@redhat.com>
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <ed038eb20804271713n79ff9b0cxa6906867d7a20f9@mail.gmail.com>
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
	 <20080425194845.GE21193@mit.edu> <ye8iqy23mhb.fsf@camel27.daimi.au.dk>
	 <ed038eb20804271713n79ff9b0cxa6906867d7a20f9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 21:41:36 +0200
Message-Id: <1209411696.14721.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 02:13 +0200, Carl Henrik Lunde wrote:
> On Mon, Apr 28, 2008 at 1:29 AM, Soeren Sandmann <sandmann@daimi.au.dk> wrote:
> [...]
> >  For a directory of ~2360 files, chunks of a 1000 files is actually
> >  surprisingly worse than statting all of the files at once:
> >
> >     Time to stat 1000 files: 1.008735 s
> >     Time to stat 1000 files: 0.738936 s
> >     Time to stat 366 files: 0.217002 s
> >
> >  I guess this just shows that seeks really is pretty much all that
> >  matters. Glib should maybe use a larger chunk size.
> 
> I agree, if I remember correctly I did not find a directory on my local
> disk where the best result was to sort a chunk instead of the complete
> directory.

I don't think that is expected either. The reason for the chunking is to
avoid unlimited memory use on large directories.

