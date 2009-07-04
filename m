Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZGDQHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZGDQHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 12:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZGDQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 12:07:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55880 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZGDQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 12:07:44 -0400
Date: Sat, 4 Jul 2009 18:07:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nix <nix@esperi.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, xb <xavier.bru@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Xeon 5500 series support in kernel
Message-ID: <20090704160743.GA19804@basil.fritz.box>
References: <4A4C770F.6000709@bull.net> <877hyrbeon.fsf@basil.nowhere.org> <87k52o65gk.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k52o65gk.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 04, 2009 at 12:41:15PM +0100, Nix wrote:
> On 2 Jul 2009, Andi Kleen outgrape:
> 
> > xb <xavier.bru@bull.net> writes:
> >
> >> I wonder if there are specific kernel configuration parameters that
> >> allow to optimize performances on the recent Xeon 5500 processors (aka
> >> Nehalem).
> >
> > The most important optimization is to use a 64bit kernel with NUMA
> > support enabled (even if you use 32bit userland)
> 
> Surely NUMA only benefits you if you have a >1 socket system? Where's

Xeons are typically multi socket. On single socket the overhead
of a NUMA kernel is negligible, so it's best to enable it always.

There are actually some use cases of NUMA kernel code for single
socket too, e.g. it is sometimes used to isolate different 
applications on the VM level.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
