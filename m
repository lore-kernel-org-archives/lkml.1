Return-Path: <linux-kernel-owner+w=401wt.eu-S967140AbXIKUk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967140AbXIKUk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbXIKUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:40:47 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:43247 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933845AbXIKUkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:40:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=N6lhm3RX3vXhNdeTcjZT3+XXvJOIzegIgUCDXddwnEEYYCqdWz+znzS+BhnPGbHfWgEx6vTXl69QHQqHbBbRGCsK/UZ+kFVrL+XjjyWkekx6swWh1UoRCYleuk2fdOD8ykumT7sP2G00b66yVuOHjFXVRFQu2hK0d/1hfVt2Z4U=  ;
X-YMail-OSG: qs5NqKIVM1l98Rw3NPqF5tWL094pUd.8BxKmlN0RPe9_MBelV0sWdB2JGS3OfRD3fEIN1Kan2Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: tbench regression - Why process scheduler has impact on tbench and why small per-cpu slab (SLUB) cache creates the scenario?
Date: Tue, 11 Sep 2007 14:59:09 +1000
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1188953218.26438.34.camel@ymzhang> <200709110117.57387.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111459.10148.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 06:19, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > The impression I got at vm meeting was that SLUB was good to go :(
>
> Its not? I have had Intel test this thoroughly and they assured me that it
> is up to SLAB. This particular case is an synthetic tests for a PAGE_SIZE
> alloc and SLUB was not optimized for that case because PAGE_SIZEd
> allocations should be handled by the page allocators. Quicklists were
> introduced for the explicit purpose to get these messy page sized cases
> out of the slab allocators.

I heard from one person at KS and one person here that it is not. If they're
simply missing some patch that's in -mm, and there is no longer a SLUB vs
SLAB regression when using equivalent page allocation order, then that's
fine.
