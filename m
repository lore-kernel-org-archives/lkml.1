Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbZCYRIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbZCYRIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZCYRHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:07:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:42973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZCYRHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:07:44 -0400
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: akataria@vmware.com
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1237999971.32497.12.camel@alok-dev1>
References: <1237281581.7907.2.camel@ht.satnam>
	 <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam>
	 <49BFC6CB.9070603@zytor.com>
	 <1237958994.5556.5.camel@localhost.localdomain>
	 <20090325125955.GB516@elte.hu>  <1237999971.32497.12.camel@alok-dev1>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 22:37:20 +0530
Message-Id: <1238000840.2500.49.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 09:52 -0700, Alok Kataria wrote:
> > 
> > vmware can be considered a CPU here, so i think making the disabling 
> > also depend on PROCESSOR_SELECT.
> 
> Ingo, this code is not just to be used by VMware, the reason we did this
> generically was so that a guest could run unaltered on *any* fully
> virtualized hypervisor.
> And give that this code is just a boot setup thing, the only thing this
> patch saves over here is not running the detection code on native
> systems. All the rest of the code is guarded by the
> "boot_cpu_data.x86_hyper_vendor" checks anyways.  
> 
> I don't really see the point of adding one more config option just for
> this. 
> 

Can you please explain what is the point of adding this support all the
time if this is useless for 99.9% of cases. IMHO, it should be optional.

--
JSR





