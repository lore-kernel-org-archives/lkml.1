Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYJAUIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYJAUIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYJAUIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:08:15 -0400
Received: from gw.goop.org ([64.81.55.164]:36375 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbYJAUIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:08:14 -0400
Message-ID: <48E3D8A8.604@goop.org>
Date: Wed, 01 Oct 2008 13:08:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: akataria@vmware.com, kvm@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       "avi@redhat.com" <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607__35819.6151479662$1222884502$gmane$org@goop.org> <48E3D7A0.3000403@codemonkey.ws>
In-Reply-To: <48E3D7A0.3000403@codemonkey.ws>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Mmm, cpuid bikeshedding :-)

My shade of blue is better.

>> The space 0x40000000-0x400000ff is reserved for hypervisor usage.
>>
>> This region is divided into 16 16-leaf blocks.  Each block has the 
>> structure:
>>
>> 0x400000x0:
>>     eax: max used leaf within the leaf block (max 0x400000xf)
>
> Why even bother with this?  It doesn't seem necessary in your proposal.

It allows someone to incrementally add things to their block in a fairly 
orderly way.  But more importantly, its the prevailing idiom, and the 
existing and proposed cpuid schemes already do this, so they'd fit in as-is.

    J
