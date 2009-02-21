Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZBUInT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZBUInT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 03:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZBUInL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 03:43:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZBUInK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 03:43:10 -0500
Message-ID: <499FBE67.7080601@zytor.com>
Date: Sat, 21 Feb 2009 00:42:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 fixes
References: <20090219171005.GA27922@elte.hu> <alpine.LFD.2.00.0902201809260.21686@localhost.localdomain> <20090221083212.GA1537@elte.hu> <20090221083910.GA12006@elte.hu>
In-Reply-To: <20090221083910.GA12006@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> | commit fa2144ba9a31d1d0dc9607508576c3850e0d95b1
>> | Author: Sam Ravnborg <sam@ravnborg.org>
>> | Date:   Fri Feb 15 13:53:11 2008 +0100
>> |
>> |     kbuild: explain why DEBUG_SECTION_MISMATCH is UNDEFINED
> 
> hm, that's 2008 not 2009.
> 
> I dont know why the section warnings went away, but i frequently 
> saw these warnings and i never forced 
> CONFIG_DEBUG_SECTION_MISMATCH on the command line.
> 

Either way, I was rather unhappy to find out that my test scripts were
silently broken by this change a year ago.  Furthermore, right now there
are only 9 section warnings in allyesconfig on x86-64 and 12 on i386,
and one of those was the one I just corrected.  The last thing we need
is them to be squelshed.

These patches should be backed out at once.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

