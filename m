Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631Ab0ANNJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0ANNJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390Ab0ANNJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:09:53 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:62447 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab0ANNJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:09:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uBu2XROCqpFfh8WYjQwkuvo+Nihj0qrF1864e+I1mqL9BOyigRPKyi1SrEbrQ6r/Lb
         Qvjzj6qLmuMqiSpBKLt6aobYpJl+tIr806VqwJhymGXiJcfWJhRw5wx2pA+rVGaMHTG9
         erf9kTpFRUMNjJRziWM0AOHSbnXjzAe2V/ejc=
Date: Thu, 14 Jan 2010 14:09:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/6] perf: Various event scheduling improvements
Message-ID: <20100114130943.GE5033@nowhere>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com> <1263473354.4244.316.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263473354.4244.316.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 01:49:14PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-01-10 at 02:38 +0100, Frederic Weisbecker wrote:
> > Hi,
> > 
> > These patches bring (I hope) a bit more scalability and fairness
> > to the perf events scheduling.
> > 
> > But this is only an introduction as there is still some work to
> > do, like ensuring all pinned events have been scheduled before
> > flexible ones (for now we schedule in order cpu pinned, cpu flexible,
> > task pinned, task flexible), among other improvements.
> 
> Right, so 1-5 look fine (although I'd have folded 5 into 3), thanks!


Ok, I'll merge 5 into 3 and send it as a pull request to Ingo
with your ack.

Thanks.

