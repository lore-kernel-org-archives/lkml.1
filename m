Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbXEIR0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbXEIR0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXEIR0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:26:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755494AbXEIR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:26:23 -0400
Date: Wed, 9 May 2007 10:25:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: david@lang.hm, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070509170742.GA29806@kroah.com>
Message-ID: <alpine.LFD.0.98.0705091023580.4062@woody.linux-foundation.org>
References: <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
 <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
 <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
 <20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
 <20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
 <20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
 <Pine.LNX.4.64.0705090910050.4467@asgard.lang.hm>
 <20070509170742.GA29806@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 May 2007, Greg KH wrote:
> > 
> >  but then won't the devices get registered in a random order? (i.e. whenever 
> >  the async portion finishes the probing and finds the details of what there 
> >  is to register)
> 
> So?  We have busses today that have devices get registered in random
> order, our userspace tools can handle it just fine now.

However, that does *not* translate to: "..so  we can do it for all buses".

People *do* depend on simple things like internal harddisks showing up in 
a particular order. The fact that you *can* handle it with UUID's etc does 
not mean that people do, or that they should be forced to do so.

There is no inherent goodness in making the bootup more random. In fact, 
there's a lot of badness to it, ranging from just not being very nice to 
"really a bitch to debug". And no amount of "user level _could_ handle it" 
changes that.

		Linus
