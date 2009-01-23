Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZAWPlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZAWPlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZAWPlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:41:31 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:20425 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753537AbZAWPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:41:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=W78bfjfhrisbt0TloXL8c4Y4+qB263Dqj5ePwUR095LWLgRuU/aiQMfKZmR8VCB0UzDZHf6nVQehbze/aJ9XB6ldRXMa+hGaGahnOoWgWe/KDcSkH5c9t46GYX76J0XYqBFblfEIvqEZDp/hGjemZzoUTC0Hz2GH6vbve1/nCjo=  ;
X-YMail-OSG: 2ddwK6wVM1l_slWEi6cQREbbG_BlPitVsqOtzl_4YYKJdDXb4sUR29rmNc6Urpgck7v6mJ_4OY9zCWfsDbayGgFnBzpounvKsaHITuJSJyL6X49IkF0Bk5BXghOEbHnujr__VevM7GKp7bUT4GT7KbMGxk1TEO_xDOT8UJtu1ft2OawH4svggieAIVrRLFGNcIVoYafHf7fydTHJ2l7zxEMqK9f2naxrFqVahMr7dT0u
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
Date: Sat, 24 Jan 2009 02:41:06 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <84144f020901230716n3f106034x8a10463b411c9a9b@mail.gmail.com> <alpine.DEB.1.10.0901231022490.21692@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901231022490.21692@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240241.06670.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 02:25:06 Christoph Lameter wrote:
> On Fri, 23 Jan 2009, Pekka Enberg wrote:
> > On Fri, Jan 23, 2009 at 5:03 PM, Christoph Lameter
> >
> > <cl@linux-foundation.org> wrote:
> > > It seems that we currently need the slab allocators to compensate for
> > > the performance problems in the page allocator for these higher order
> > > allocs. I'd rather have the page allocator fixed but things are as they
> > > are.
> >
> > So, is that an ACK or a NAK for the patch?-)
>
> Doesnt that break down Nick's order-0 dominates-the-world scheme break
> down?

SLUB is your scheme. And yes it definitely goes against my liking of
order-0 allocations regardless of this patch.


> One of the reasons for doing this was to get the page allocator
> performance issues exposed and addressed.

Page allocator is never going to be as fast as slab allocator, for
issues I explained a long time ago. Not to say it can't be improved,
just stating facts.

