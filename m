Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992AbZDNEot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbZDNEot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZDNEok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:44:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZDNEoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:44:39 -0400
Message-ID: <49E41447.2060400@zytor.com>
Date: Mon, 13 Apr 2009 21:42:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, alan-jenkins@tuffmail.co.uk,
       Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@sisk.pl,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com> <20090413041625.GF11652@elte.hu> <20090413042459.GA6479@elte.hu> <49E367E8.7080202@zytor.com> <9b2b86520904131134y26f508ffr2bc0303eff203a25@mail.gmail.com> <49E38DBD.8040303@linux.intel.com> <20090414000627.GL817@elte.hu>
In-Reply-To: <20090414000627.GL817@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> ... looks like an x86 descriptor table. Does the pattern below make 
> any sense to anyone? I've attached the relevant bits of one of the 
> reports below.
> 

It's weird... it's clearly not random, but the pattern is shifting all
over the place.  Almost makes me want to guess some kind of bitmask (the
0xaaaaaa00 bit and the stretches of 00 and ff kind of hint that way) but
even then it doesn't really seem to make a whole lot of sense.  Perhaps
it's a data segment of some code which is barfing on memory.

960 bytes at 0xc000 (48K)... almost makes one wonder if someone confused
address 0xc000 with segment 0xc000 (the VGA BIOS)...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

