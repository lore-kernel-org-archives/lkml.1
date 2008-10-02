Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYJBBPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYJBBPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYJBBO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:14:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYJBBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:14:57 -0400
Message-ID: <48E41C94.7040904@kernel.org>
Date: Wed, 01 Oct 2008 17:57:56 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alok Kataria <akataria@vmware.com>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>	 <1222894878.9381.63.camel@alok-dev1> <48E3E8DE.1080602@goop.org>	 <48E3ECD1.30809@codemonkey.ws> <1222904824.7330.83.camel@bodhitayantram.eng.vmware.com> <48E4183A.7090208@zytor.com>
In-Reply-To: <48E4183A.7090208@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Ah, if it was only that simple.  Transmeta actually did this, but it's 
> not as useful as you think.
> 

For what it's worth, Transmeta's implementation used CPUID leaf 
0x80860001.ECX to give the TSC frequency rounded to the nearest MHz. 
The caveat of spread-spectrum modulation applies.

	-hpa
