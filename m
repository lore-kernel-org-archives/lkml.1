Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYCOVMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYCOVMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYCOVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:12:30 -0400
Received: from 1wt.eu ([62.212.114.60]:2479 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbYCOVMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:12:30 -0400
Date: Sat, 15 Mar 2008 22:11:25 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: K8, EFFICEON and CORE2 support the cmovxx instructions.
Message-ID: <20080315211125.GB13012@1wt.eu>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314195520.GV2522@one.firstfloor.org> <1205530409.27413.1242484373@webmail.messagingengine.com> <20080315191946.GA21817@mailshack.com> <47DC2F08.9080004@zytor.com> <1205615192.29139.1242596503@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205615192.29139.1242596503@webmail.messagingengine.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 10:06:32PM +0100, Alexander van Heukelum wrote:
> > > I'm quite sure that K8, EFFICEON and CORE2 support HAVE_CMOV, but
> > > they did not set X86_CMOV.
> > > 
> > 
> > Crusoe has CMOV as well.

So does GEODE_LX BTW

> I believe you... and the Makefile_32.cpu: it gets a -march=i686. I
> also found out that I missed X86_ELAN, which is treated as a i486.
> 
> Also, MGEODE_LX does not get any optimization flags. I think that
> is unintentional, but what should they be?

in my experience (on user-space code), optimizing for "i586" gives
good results. However, the cache is small, so everything which can
reduce code size (especially loop/jump/function alignment) is worth
checking.

Regards,
Willy

