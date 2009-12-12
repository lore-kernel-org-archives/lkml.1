Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbZLLDZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbZLLDZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 22:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932843AbZLLDZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 22:25:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:31048 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbZLLDZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 22:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=arIpzkyn1kSy66EhrEJgEsvyfS1vEnA8phz4z7xCCmVqnYHvB/HgKyU6pV5Xxc5Poc
         sj+W0PkesVETHXPKVDX+xaKjMlQnXXfEIqtfvZzizrYI2lbx+lVFVWCbKUcDcIuNv/C3
         uTFmBE5i7U3qZTEDTVjV9aTpb9r801Y3w/vbY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Date: Sat, 12 Dec 2009 04:22:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200912111124.18118.kernel@kolivas.org> <200912120155.39197.bzolnier@gmail.com> <200912121300.54803.kernel@kolivas.org>
In-Reply-To: <200912121300.54803.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912120422.15372.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009 03:00:54 am Con Kolivas wrote:
> On Sat, 12 Dec 2009 11:55:39 Bartlomiej Zolnierkiewicz wrote:
> > On Friday 11 December 2009 11:37:42 pm Con Kolivas wrote:
> > > On Sat, 12 Dec 2009 02:12:58 Christoph Lameter wrote:
> > > > On Sat, 12 Dec 2009, Con Kolivas wrote:
> > > > > On Sat, 12 Dec 2009 01:10:39 Christoph Lameter wrote:
> > > > > > Could you make the scheduler build time configurable instead of
> > > > > > replacing the existing one? Embedded folks in particular may love a
> > > > > > low footprint scheduler.
> > > > >
> > > > > It's not a bad idea, but the kernel still needs to be patched either
> > > > > way. To get BFS they'd need to patch the kernel. If they didn't want
> > > > > BFS, they wouldn't patch it in the first place.
> > > >
> > > > BFS would have a chance to be merged as an alternate scheduler for
> > > > specialized situations (such as embedded or desktop use).
> > >
> > > Nice idea, but regardless of who else might want that, the mainline
> > 
> > FWIW I would also love to see it happen.
> 
> Thanks!
> 
> > > maintainers have already made it clear they do not.
> > 
> > Oh, those upstream bastards.. ;)
> > 
> > Why do you care so much about their acknowledgment?
> 
> Whaa...?
> 
> > 
> > If you are not doing your unpaid kernel work for yourself and for people
> > who recognize/use it then upstream maintainers not liking your changes
> > should really be the least of your worries..
> > 
> 
> Wait, this does not make sense. There's a cyclical flaw in this reasoning. If 
> I cared about their acknowledgment, I would make it mainline mergeable and 
> argue a case for it, which I do not want to do. 

Unfortunately the flaw is in your reasoning..

> I'm happy to make reasonable changes to the code consistent with what people 
> who use it want, but what exactly is the point of making it mainline mergeable 
> if it will not be merged?

The thing is that those two points are not necessarily a conflicting ones..

--
Bartlomiej Zolnierkiewicz
