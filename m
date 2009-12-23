Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZLWSBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZLWSBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZLWSBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:01:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbZLWSBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:01:35 -0500
Date: Wed, 23 Dec 2009 10:01:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Hounschell <markh@compro.net>
cc: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
In-Reply-To: <4B32565E.6000501@compro.net>
Message-ID: <alpine.LFD.2.00.0912230955590.6879@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net> <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>
 <4B2BE05B.9050006@compro.net> <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain> <4B30E1B4.7000702@compro.net> <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain> <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdo
 main> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org>
 <4B32565E.6000501@compro.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Dec 2009, Mark Hounschell wrote:
> 
> I'll try the patch Linus provided now.

I doubt it matters - because if it did, it would matter for everybody, and 
the HPET thing shouldn't make any difference at all.

[ Or rather, it should matter for everybody trying to format a specific 
  format (without interleave it won't matter, and not all formats have any 
  interleave - I think it was mainly used on 5.25" floppies and special 
  formats). ]

Besides, maybe I was just mis-reading the code.

But getting some testing for the patch certainly won't hurt, so I'm not 
going to argue against it any more ;)

		Linus
