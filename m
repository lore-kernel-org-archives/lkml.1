Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYJAVGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYJAVGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYJAVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:05:56 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:58614 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbYJAVF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:05:56 -0400
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors
	and	Linux.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <48E3BC21.4080803@goop.org>
References: <1222881242.9381.17.camel@alok-dev1>
	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>
	 <48E3BC21.4080803@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 01 Oct 2008 14:05:53 -0700
Message-Id: <1222895153.9381.69.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 11:06 -0700, Jeremy Fitzhardinge wrote:
> Alok Kataria wrote:
> > Its not a user who has to do anything special here.
> > There are *intelligent* VM developers out there who can export a
> > different CPUid interface depending on the guest OS type. And this is
> > what most of the hypervisors do (not necessarily for CPUID, but for
> > other things right now).
> >
> 
> No, that's always a terrible idea.  Sure, its necessary to deal with
> some backward-compatibility issues, but we should even consider a new
> interface which assumes this kind of thing.  We want properly enumerable
> interfaces.

The reason we still have to do this is because, Microsoft has already
defined a CPUID format which is way different than what you or I are
proposing ( with the current case of 256 leafs being available). And I
doubt they would change the way they deal with it on their OS. 
Any proposal that we go with, we will have to export different CPUID
interface from the hypervisor for the 2 OS in question. 

So i think this is something that we anyways will have to do and not
worth binging about in the discussion.

--
Alok

>     J

