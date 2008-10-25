Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbYJYIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbYJYIUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 04:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYJYIUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 04:20:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJYIUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 04:20:31 -0400
Subject: Re: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
From: David Woodhouse <dwmw2@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1224905479.3248.126.camel@calx>
References: <1224879959.3248.32.camel@calx>
	 <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz>
	 <1224890002.3248.71.camel@calx>
	 <200810242046.02743.dmitry.torokhov@gmail.com>
	 <1224905479.3248.126.camel@calx>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 09:20:25 +0100
Message-Id: <1224922825.18031.16.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 22:31 -0500, Matt Mackall wrote:
> Ideally, we'd find a way to (a) store variable-length string constants
> in init sections and (b) teach modpost about following pointers.

Doing (b) shouldn't be _so_ hard. Modpost already trawls through the
relocations, looking for naughty ones. Making it actually _do_ them when
it needs to shouldn't be impossible.

> Something like this would work inside code but sadly not inside
> declarations:
> 
> #define ISTR(s) ({static char c[] __attribute__ ((section("__initdata__"))) = s;c;})

Yeah, I played with that for a while, but gave up.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

