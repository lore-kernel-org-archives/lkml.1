Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbZCQJth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbZCQJth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZCQJt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:49:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:52321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZCQJtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:49:25 -0400
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akataria@vmware.com
In-Reply-To: <20090317093919.GD6477@elte.hu>
References: <1237281581.7907.2.camel@ht.satnam>
	 <20090317093919.GD6477@elte.hu>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 15:18:38 +0530
Message-Id: <1237283318.7907.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 10:39 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Subject: [PATCH] x86: move vmware to hypervisor
> > 
> > Impact: cleanup
> > 
> > vmware is only required by hypervisor and having only two functions
> > by moving these two functions to hypervisor we get rid of 2 vmware files
> > 
> > Added support for CONFIG_X86_HYPERVISOR
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/Kconfig                  |   12 ++++
> >  arch/x86/include/asm/hypervisor.h |   34 ++++++++++-
> >  arch/x86/include/asm/vmware.h     |   27 ---------
> >  arch/x86/kernel/cpu/Makefile      |    2 +-
> >  arch/x86/kernel/cpu/hypervisor.c  |   80 ++++++++++++++++++++-------
> >  arch/x86/kernel/cpu/vmware.c      |  112 -------------------------------------
> >  6 files changed, 104 insertions(+), 163 deletions(-)
> >  delete mode 100644 arch/x86/include/asm/vmware.h
> >  delete mode 100644 arch/x86/kernel/cpu/vmware.c
> 
> I dont really like this one. KVM is a hypervisor too, and so is 
> Xen and lguest. VMware is one of the many types of a 
> hypervisors.
> 

Can we use common hypervisor for Xen, lguest, vmware, etc.
And Xen, lguest, vmware will be the sub-options.

--
JSR

