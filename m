Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYJARZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYJARZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYJARZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:25:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYJARZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:25:28 -0400
Message-ID: <48E3B19D.6060905@zytor.com>
Date: Wed, 01 Oct 2008 10:21:33 -0700
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
> (This proposal may be adopted by other guest OSes.  However, that is not
> a requirement because a hypervisor can expose a different CPUID
> interface depending on the guest OS type that is specified by the VM
> configuration.)
> 

Excuse me, but that is blatantly idiotic.  Expecting the user having to 
configure a VM to match the target OS is *exactly* as stupid as 
expecting the user to reconfigure the BIOS.  It's totally the wrong 
thing to do.

	-hpa
