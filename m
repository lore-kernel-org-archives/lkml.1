Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYJARvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYJARvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJARvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:51:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35583 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYJARvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:51:20 -0400
Message-ID: <48E3B7C4.2020707@zytor.com>
Date: Wed, 01 Oct 2008 10:47:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1>
In-Reply-To: <1222881242.9381.17.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> Hypervisor CPUID Interface Proposal
> -----------------------------------
> 
> Intel & AMD have reserved cpuid levels 0x40000000 - 0x400000FF for
> software use.  Hypervisors can use these levels to provide an interface
> to pass information from the hypervisor to the guest running inside a
> virtual machine.
> 
> This proposal defines a standard framework for the way in which the
> Linux and hypervisor communities incrementally define this CPUID space.
> 

I also observe that your proposal provides no mean of positive 
identification, i.e. that a hypervisor actually conforms to your proposal.

	-hpa
