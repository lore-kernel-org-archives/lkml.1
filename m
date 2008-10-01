Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYJAUFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYJAUFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYJAUEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:04:52 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:10223 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYJAUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:04:52 -0400
Message-ID: <48E3D7A0.3000403@codemonkey.ws>
Date: Wed, 01 Oct 2008 15:03:44 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: akataria@vmware.com, kvm@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       "avi@redhat.com" <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607__35819.6151479662$1222884502$gmane$org@goop.org>
In-Reply-To: <48E3BBC1.2050607__35819.6151479662$1222884502$gmane$org@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Alok Kataria wrote:
> 
> No, we're not getting anywhere.  This is an outright broken idea.  The 
> space is too small to be able to chop up in this way, and the number of 
> vendors too large to be able to do it without having a central oversight.
> 
> The only way this can work is by having explicit positive identification 
> of each group of leaves with a signature.  If there's a recognizable 
> signature, then you can inspect the rest of the group; if not, then you 
> can't.  That way, you can avoid any leaf usage which doesn't conform to 
> this model, and you can also simultaneously support multiple hypervisor 
> ABIs.  It also accommodates existing hypervisor use of this leaf space, 
> even if they currently use a fixed location within it.
> 
> A concrete counter-proposal:

Mmm, cpuid bikeshedding :-)

> The space 0x40000000-0x400000ff is reserved for hypervisor usage.
> 
> This region is divided into 16 16-leaf blocks.  Each block has the 
> structure:
> 
> 0x400000x0:
>     eax: max used leaf within the leaf block (max 0x400000xf)

Why even bother with this?  It doesn't seem necessary in your proposal.

Regards,

Anthony Liguori
