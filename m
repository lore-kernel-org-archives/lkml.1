Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYJUVmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYJUVmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYJUVl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:41:59 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60879 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbYJUVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:41:58 -0400
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <1224618463.6161.82.camel@alok-dev1>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
	 <1224618463.6161.82.camel@alok-dev1>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 14:41:56 -0700
Message-Id: <1224625316.6161.105.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 12:47 -0700, Alok Kataria wrote:
> On Tue, 2008-10-21 at 12:27 -0700, Andi Kleen wrote:
> > On Tue, Oct 21, 2008 at 12:10:36PM -0700, Alok Kataria wrote:
> > > On Tue, 2008-10-21 at 11:15 -0700, Andi Kleen wrote:

> > When the margin changes then it likely won't be good enough for
> > gettimeofday(). There are a couple of testers for monotonity around,
> > would such a system with shifting marging surive running them
> > for a few days?
> 
> I meant, the margin changes when you are running different flavors of
> the build, or running different user configurations (from overcommitment
> POV). Once a system is booted the margin won't vary, apart from the
> bootup stage which will always have some extreme states. In all our
> internal testing that has been done, 

> we have never noticed time drift is
> withing the NTP threshold when its compared to the host system, under
> varying load. 
> 

oops... i meant the time drift is _always_ within the NTP threshold.


