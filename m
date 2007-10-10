Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbXJJT0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbXJJT0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbXJJT0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:26:45 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21156 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbXJJT0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:26:44 -0400
Message-ID: <470D2771.2040806@msgid.tls.msk.ru>
Date: Wed, 10 Oct 2007 23:26:41 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Ren=E9_Rebe?= <rene@exactcode.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org> <200710100944.16378.rene@exactcode.de> <20071010191413.GB3589@elte.hu>
In-Reply-To: <20071010191413.GB3589@elte.hu>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * René Rebe <rene@exactcode.de> wrote:
> 
>> Hi Linus et al.,
>>
>> 2.6.23 does not build with my usual .config on x86_64 and gcc-4.2.1:
[]
> your superblock build failure would be a new and so far unknown build 
> breakage variant - please send the .config you used, and double-check 
> that it's indeed a vanilla 2.6.23 tree.

It's not a vanilla 2.6.23.  In vanilla 2.6.23 there's no lines about
which it complains (struct super_block isn't mentioned in mm.h at all).
It's some external patch that used to work with 2.6.22 but needs to be
updated for 2.6.23 - in my case it was unionfs.

/mjt
