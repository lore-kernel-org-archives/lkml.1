Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbXCZQW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbXCZQW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 12:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXCZQW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 12:22:26 -0400
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:56603 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbXCZQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 12:22:25 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: debug rsdl 0.33
Date: Tue, 27 Mar 2007 02:12:59 +1000
User-Agent: KMail/1.9.5
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <46077AEE.8060507@shadowen.org> <4607E6A8.3040308@shadowen.org>
In-Reply-To: <4607E6A8.3040308@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703270213.00371.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 01:28, Andy Whitcroft wrote:
> Andy Whitcroft wrote:
> Subsequent to that Con suggested testing a refactored RSDL patch.  That
> patch seemed to work on the machine at hand, so tests have been
> submitted for all the affected machines.
>
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-mm1-rsdl-0.34-t
>est.patch
>
> ...
>
> Ok, the preliminary results are in and we seem to have good boots in the
> three machines I was hitting early boot oops.  So I think we can say
> that the new stack is a lot better than the old.
>
> Con, have a Tested-by:
> :/
>
> -apw

Well thank you very much indeed. I'm pleased that the code I decided to rip 
out of the next update also took whatever bug was there with it. Fortunately 
it also is not dependant on the buggy sched: accurate user accounting patch 
that I gave up on so here is an incremental from the current -mm queue to 
this code without the "accurate user accounting patch" component for anyone 
who's trying to track just what I'm planning on moving forward with.

http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-mm1/sched-rsdl-sd-0.35-test.patch

Summary:
 3 files changed, 86 insertions(+), 249 deletions(-)

It also makes lists-add_list_splice_tail.patch unnecessary

-- 
-ck
