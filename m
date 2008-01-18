Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbYAROP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbYAROP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYAROPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:15:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54505 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbYAROPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:15:22 -0500
Date: Fri, 18 Jan 2008 15:18:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle McMartin <kyle@mcmartin.ca>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
Message-ID: <20080118141839.GA16738@one.firstfloor.org>
References: <20080118045921.GB974@phobos.i.cabal.ca> <p734pdbbrwu.fsf@bingen.suse.de> <20080118060124.GC1726@phobos.i.cabal.ca> <479046BA.7090903@zytor.com> <20080118065428.GA12594@one.firstfloor.org> <4790B01B.8020406@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4790B01B.8020406@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 08:56:43AM -0500, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >>Simulators can be fixed, 
> >
> >They could, but why? I don't know of a good reason to require CLFLUSH.
> 
> Well, simulators are generally expected to follow the architecture, not 
> vice versa.  I would tend to agree with the coupling that recent 
> versions of Bochs appeared to have made here -- I think we're unlikely 
> to see any processors with sse2 sans clflush, so keeping code branches 
> in which will never be executed seems like a bad idea in the long term. 

Here's another argument: Ingo just asked me to add a noclflush option
to the code. Guess what check that option will need? 

Besides compared to the cost of a flushing clflush the branches are absolutely 
in the noise.

-Andi
