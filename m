Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXLURo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXLURo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 12:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXLURoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 12:44:20 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:24145 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXLURoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 12:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A6CebSz7l3sRF08OwcyGxsDSW5PfxUfTyICyyljd2Fed27oPJUa0/T0ltU4zVzPMgVBZqYXq5cFK6UP8tGFDM8bL1EfViqqWDSUk/941ZXH+0STf0ZD5PB85QR5lE8YPppf1EUFnQRpUcbMc891NP+x1qPob1VRxYTE42BIFWZI=
Message-ID: <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com>
Date: Fri, 21 Dec 2007 19:44:12 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071221120908.GA15926@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197049846.1645.68.camel@localhost.localdomain>
	 <20071211143336.GA17866@elte.hu>
	 <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
	 <20071221120908.GA15926@elte.hu>
X-Google-Sender-Auth: 0235951824e0345b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christoph Lameter <clameter@sgi.com> wrote:
> > In an extreme case (boot with slub_min_order=9 to get huge page sized
> > slabs) SLUB can win against SLAB:
> >
> > N=10 Time: 0.338      Minimally faster
> > N=20 Time: 0.560      10% faster
> > N=50 Time: 1.353      15% faster

On Dec 21, 2007 2:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
> what's up with this regression? There's been absolutely no activity
> about it in the last 8 days: upstream still regresses, -mm still
> regresses and there are no patches posted for testing.

Christoph, did you see Steven's oprofile results for the hackbench
runs (http://lkml.org/lkml/2007/12/8/198)? Any ideas why we're hitting
add_partial like crazy?

                                Pekka
