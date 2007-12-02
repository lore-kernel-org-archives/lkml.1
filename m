Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXLBEYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXLBEYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 23:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXLBEYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 23:24:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbXLBEYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 23:24:44 -0500
Date: Sat, 1 Dec 2007 20:23:54 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: namespace support requires network modules to say "GPL"
Message-ID: <20071201202354.672aed18@freepuppy.rosehill>
In-Reply-To: <475227B1.2060802@rtr.ca>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca>
	<20071201111736.297dd99a@freepuppy.rosehill>
	<20071201163035.321fd554@freepuppy.rosehill>
	<475227B1.2060802@rtr.ca>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2007 22:34:09 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Stephen Hemminger wrote:
> > On Sat, 1 Dec 2007 11:17:36 -0800
> > Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > 
> >> Then init_net needs to be not GPL limited. Sorry, we need to allow
> >> non GPL network drivers.  There is a fine line between keeping the
> >> binary seething masses from accessing random kernel functions, and allowing
> >> reasonable (but still non GPL) things like ndiswrapper to use network
> >> device interface.
> >>
> > I spoke too soon earlier, ndiswrapper builds and loads against current
> > 2.6.24-rc3. Vmware and proprietary VPN software probably do not. Once again I don't
> > give a damn, but the enterprise distro vendors certainly care.
> ...
> 
> Naw, enterprise (or any other) distro vendors shouldn't have any issues here,
> since they can just patch their kernels around any issues.
> 
> But it looks like Eric has this one thought out well enough.

So you are saying all this is not a problem, fine.
Any affected parties can certainly lobby for themselves. But I suspect
they all think the kernel community is a bunch of ... and will just ignore
the problem. 

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
