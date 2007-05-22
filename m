Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXEVAP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXEVAP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXEVAPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:15:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:44713 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbXEVAPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:15:15 -0400
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 May 2007 10:15:07 +1000
Message-Id: <1179792908.32247.772.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 18:14 +0100, Dave Airlie wrote:
> 
> > 6) Eliminate the existing VT swap driver free for all. I would
> compile
> > out the VT layer and replace it with a compatible API that enforces
> > some sanity.
> 
> I'm hoping to look into this but it is a parallel problem to what this
> code does, the VT switch API sucks rocks, so providing something
> compatible is going to suck rocks..

Yeah, please, don't even go near that until everything else is done &
merged or you'll never have anything finished :-) VT is a can of worms
that will take some time to sort out and has nothing to do with what we
are talking about right now anyway :-)

Ben.


