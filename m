Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbZHZTQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbZHZTQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbZHZTQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:16:12 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:33354 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbZHZTQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:16:11 -0400
Date: Wed, 26 Aug 2009 15:15:49 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <20090826180407.GA13632@elte.hu>
Message-ID: <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
References: <4A943A00.9080609@nortel.com> <1251264700.7538.1178.camel@twins> <1251282598.3514.20.camel@raz> <alpine.DEB.1.10.0908260943090.9924@gentwo.org> <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins>
 <alpine.DEB.1.10.0908261136590.9933@gentwo.org> <1251302598.18584.31.camel@twins> <alpine.DEB.1.10.0908261211340.9933@gentwo.org> <20090826180407.GA13632@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Ingo Molnar wrote:

> The thing is, you have cut out (and have not replied to) this
> crutial bit of what Peter wrote:
>
> > > The past year or so you've been whining about the tick latency,
> > > and I've seen exactly _0_ patches from you slimming down the
> > > work done in there, even though I pointed out some obvious
> > > things that could be done.
>
> ... which pretty much settles the issue as far as i'm concerned. If
> you were truly interested in a constructive solution to lower
> latencies in Linux you should have sent patches already for the low
> hanging fruits Peter pointed out.

The noise latencies were already reduced in years earlier to the mininum
(f.e. the work on slab queue cleaning). Certainly more could be done there
but that misses the point.

The point of the OFFLINE scheduler is to completely eliminate the
OS disturbances by getting rid of *all* OS processing on some cpus.

For some reason scheduler developers seem to be threatened by this idea
and they go into bizarre lines of arguments to avoid the issue. Its simple
and doable and the scheduler will still be there after we do this.

