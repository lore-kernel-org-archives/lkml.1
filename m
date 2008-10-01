Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYJAReE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYJAReE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYJARdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:33:52 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59774 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYJARdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:33:52 -0400
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and
	Linux.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <48E3B19D.6060905@zytor.com>
References: <1222881242.9381.17.camel@alok-dev1>
	 <48E3B19D.6060905@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 01 Oct 2008 10:33:51 -0700
Message-Id: <1222882431.9381.23.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 10:21 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> >
> > (This proposal may be adopted by other guest OSes.  However, that is not
> > a requirement because a hypervisor can expose a different CPUID
> > interface depending on the guest OS type that is specified by the VM
> > configuration.)
> >
> 
> Excuse me, but that is blatantly idiotic.  Expecting the user having to
> configure a VM to match the target OS is *exactly* as stupid as
> expecting the user to reconfigure the BIOS.  It's totally the wrong
> thing to do.

Hi Peter, 

Its not a user who has to do anything special here.
There are *intelligent* VM developers out there who can export a
different CPUid interface depending on the guest OS type. And this is
what most of the hypervisors do (not necessarily for CPUID, but for
other things right now).

Alok.
> 
>         -hpa

