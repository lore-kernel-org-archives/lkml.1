Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYFLR6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYFLR6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYFLR6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:58:05 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:47834 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752356AbYFLR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:58:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=h10fmSpp6xOyL7+1kObVT7UoRR/O/Z2Rv/DIomx/zXLit4ttA6iLirZe48eJ5vp9/agdILQbZT+n7MElk9sSw26nx26DORv075UTGlYCPH4EhxNsQ3K7lTh/dUQ6KC+mwXbiRQZ/5kC+lQXJCDtH6wnBgVdA/T7IdaMKztUz8ww=  ;
X-YMail-OSG: TzhJ2mMVM1kDrhtLnLIK.FWvLC4io3rxbwpRTl9IeGbV8RVm33E9gO5jwKuco1rltItTFtvnesgDrIyOVJd6rVxJmlXA5Xr1EEEUaj_HPub_K8PC6GdRDkNkAaBvbNNrgog-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm 14/24] Ramfs and Ram Disk pages are unevictable
Date: Fri, 13 Jun 2008 03:57:53 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>
References: <20080611184214.605110868@redhat.com> <200806130337.57118.nickpiggin@yahoo.com.au> <20080612135014.026cc2e3@cuia.bos.redhat.com>
In-Reply-To: <20080612135014.026cc2e3@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806130357.53669.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 03:50, Rik van Riel wrote:
> On Fri, 13 Jun 2008 03:37:56 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > This isn't the case for brd any longer. It doesn't use the buffer
> > > > cache as its backing store, so the buffer cache is reclaimable.
> > >
> > > I know that pages of files that got paged into the page
> > > cache from the ramdisk can be evicted (back to the ram
> > > disk), but how do the brd pages themselves behave?
> >
> > They are not reclaimable. But they have nothing (directly) to do
> > with brd's i_mapping address space, nor are they put on any LRU
> > lists.
>
> Ahhhh, doh!
>
> I'm mailing Andrew a patch right now that undoes the
> brd.c part of patch 14/24. The ramdisk part is correct
> and should stay (afaict).

The ramfs part? Yes, that looks correct to me.
