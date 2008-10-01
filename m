Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYJASGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYJASGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYJASGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:06:31 -0400
Received: from gw.goop.org ([64.81.55.164]:45285 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbYJASGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:06:30 -0400
Message-ID: <48E3BC21.4080803@goop.org>
Date: Wed, 01 Oct 2008 11:06:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: akataria@vmware.com
CC: "H. Peter Anvin" <hpa@zytor.com>, "avi@redhat.com" <avi@redhat.com>,
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
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Its not a user who has to do anything special here.
> There are *intelligent* VM developers out there who can export a
> different CPUid interface depending on the guest OS type. And this is
> what most of the hypervisors do (not necessarily for CPUID, but for
> other things right now).
>   

No, that's always a terrible idea.  Sure, its necessary to deal with 
some backward-compatibility issues, but we should even consider a new 
interface which assumes this kind of thing.  We want properly enumerable 
interfaces.

    J
