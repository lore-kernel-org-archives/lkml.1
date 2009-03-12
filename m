Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZCLOUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZCLOUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZCLOT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:19:59 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:46082 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755317AbZCLOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:19:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fDZwGVPxPzZbKOj7Zyb2oq2hCz83haHTV6Kd5N5xogiSnk8RI4XbwRXz2OVuq+X7oTAlyGqp4saXBYIJPtCCq/TN1LqCGc+xESM9H1QKQYRYercwCwciT7H+pAYK/Ce6B0z/snlMLaHr7Sm98eJ0qU4MdGVMw91OtoeWhmxFiBk=  ;
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Fri, 13 Mar 2009 01:19:51 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au> <20090312135940.GB14425@parisc-linux.org>
In-Reply-To: <20090312135940.GB14425@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130119.52039.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 00:59:40 Matthew Wilcox wrote:
> On Fri, Mar 13, 2009 at 12:04:40AM +1100, Nick Piggin wrote:
> > As far as the per-block pagecache state (as opposed to the per-block fs
> > state), I don't see any reason it is a problem for efficiency. We have to
> > do per-page operations anyway.
>
> Why?  Wouldn't it be nice if we could do arbitrary extents?  I suppose
> superpages or soft page sizes get us most of the way there, but the
> rounding or pieces at the end are a bit of a pain.  Sure, it'll be a
> huge upheaval for the VM, but we're good at huge upheavals ;-)

Sounds nice in theory. I personally think it would be very very hard to
do well, and wouldn't and up being much of a win if at all anyway.

But if you have some structure representing arbitrary pagecache extents,
then you would probably be able to naturally use those pagecache extents
themselves, or parallel very similar data structures for holding block
state.


