Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYI2VLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYI2VLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYI2VLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:11:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYI2VLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:11:08 -0400
Message-ID: <48E1437D.7080606@zytor.com>
Date: Mon, 29 Sep 2008 14:07:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: "akataria@vmware.com" <akataria@vmware.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1> <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> 
> For example, we can set the following ranges so that so that each VMM vender can define and implement features avoiding conflicts:
> vmware to define 0x4000001X
> xen to define 0x4000002X
> kvm to define 0x4000003X
> ...
> 

Unless there is a central authority assigning these, "we" can do all we 
want, enough people will not pay attention.

Basically, there needs to be a standards document that describes the 
architecture, *and* needs to either have universal buy-in with all the 
vendors or imposed by an authority with enough clout to do so (Intel might.)

	-hpa
