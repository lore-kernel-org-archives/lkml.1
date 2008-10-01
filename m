Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYJARt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYJARt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYJARtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:49:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYJARts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:49:48 -0400
Message-ID: <48E3B753.7000309@zytor.com>
Date: Wed, 01 Oct 2008 10:45:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and	Linux.
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>
In-Reply-To: <1222882431.9381.23.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> Hi Peter, 
> 
> Its not a user who has to do anything special here.
> There are *intelligent* VM developers out there who can export a
> different CPUid interface depending on the guest OS type. And this is
> what most of the hypervisors do (not necessarily for CPUID, but for
> other things right now).
> 

It doesn't matter, really; it's still the wrong thing to do, for the 
same reason it's the wrong thing in -- for example -- ACPI, which has 
similar "cleverness".

If we want to have a "Linux standard CPUID interface" suite we should 
just put them on a different set of numbers and let a hypervisor export 
all the interfaces.

	-hpa
