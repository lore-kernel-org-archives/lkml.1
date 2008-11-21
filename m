Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYKUT2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYKUT2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYKUT2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:28:46 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbYKUT2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:28:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=MaaSH0bezOraDdElfCw+N8iZMk/IId4Lr/Nyuf7DpVaWBOos+q9DL/I9e507FHXEV
	wdJugdFfKfGqdQ5Tph46g==
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Frank Mayhar <fmayhar@google.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200811211942.43848.ptesarik@suse.cz>
References: <1224694989.8431.23.camel@oberon>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>  <200811211942.43848.ptesarik@suse.cz>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 21 Nov 2008 11:26:03 -0800
Message-Id: <1227295563.21605.13.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 19:42 +0100, Petr Tesarik wrote:
> This is just not true. I've seen a very real example of a lockup with a very 
> sane number of threads (one per CPU), but on a very large machine (1024 CPUs 
> IIRC). The application set per-process CPU profiling with an interval of 1 
> tick, which translates to 1024 timers firing off with each tick...
> 
> Well, yes, that was broken, too, but that's the way one quite popular FORTRAN 
> compiler works...

Petr, have you tried the fix in the latest kernel?  Does it help?  I'm
intensely curious to know how it affected your runs.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

