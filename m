Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbZCOD7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbZCOD7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZCOD7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:59:04 -0400
Received: from phunq.net ([64.81.85.152]:39861 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755678AbZCOD7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:59:03 -0400
From: Daniel Phillips <phillips@phunq.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 20:58:57 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090312130222.b149cf36.akpm@linux-foundation.org> <87k56ulb9s.fsf@devron.myhome.or.jp>
In-Reply-To: <87k56ulb9s.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142058.58124.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, OGAWA Hirofumi wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Fri, 13 Mar 2009 01:18:29 +0900
> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> >
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >> 
> >> > - When 'bh' is known to be non-NULL, use put_bh() rather than brelse().
> >> 
> >> It sounds strange. Almost all bh is non-NULL. This means we are going to
> >> replace almost all brelse() by put_bh()?
> >> 
> >
> > Well..  you can make up your own mind about this.  If you see benefit
> > in the NULL-checking and extra debugging which brelse() provides then
> > continue to use brelse().
> 
> I thought someone started to convert it. Ok, personally, I think
> NULL-check is just not needed always, and if it is needed, check it
> explicitly.

I checked in a patch last week to convert all the brelses to "blockput"
(note how close the spelling is to Nick's block_put, an unsurprising
accident).  This should mean a little less work when the time comes to
try out the block handles idea, and it surely doesn't hurt anything.

Regards,

Daniel
