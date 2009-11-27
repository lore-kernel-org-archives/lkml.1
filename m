Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZK0Wme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZK0Wme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZK0Wmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:42:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:11515 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZK0Wmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:42:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IZ3EDibNvHhZIKliPlJV1FEpjPACs3+/TF8N47I/ZUTM1OyHCEFBfr0QaoLviZ8172
         13L1BUz8GSLqkqmykRuDOfidFTdWYSlCjY0GsN4kj/ZLoOMOOWrFyLLOuhsmR5nXjhxT
         L0mDM77pnBX0vOM2Ry155QxNBmG3GxfPhlaP0=
Date: Fri, 27 Nov 2009 23:42:06 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091127224206.GA3350@ami.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
 <20091124111946.GA7883@ff.dom.local>
 <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
 <20091125191105.GA3167@ami.dom.local>
 <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
 <20091127213640.GA2611@ami.dom.local>
 <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 05:35:34PM -0500, Caleb Cushing wrote:
> > I doubt bisecting is a good idea with so unpredictable bug. First, you
> > should make sure it's not a hardware problem, so go back to the kernel
> > you trust most, and give it a really long try with a few recompilations
> > after slightly changing the config. Btw, I wonder if you tried e1000e
> > module parameters like IntMode=0 or 1.
> 
> no, how do I set those?

modprobe -r e1000e
modprobe e1000e IntMode=0

Jarek P.
