Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbYGRTJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbYGRTJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbYGRTJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:09:41 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63555 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754928AbYGRTJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:09:41 -0400
Date: Fri, 18 Jul 2008 20:09:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
In-Reply-To: <20080718174931.GE6897@asus>
Message-ID: <Pine.LNX.4.55.0807182005330.12125@cliff.in.clinika.pl>
References: <20080718172821.GA4149@localhost.localdomain> <20080718174413.GD6897@asus>
 <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com>
 <20080718174931.GE6897@asus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Cyrill Gorcunov wrote:

> iirc, they all were there (though some error codes are specific for
> particular processor classes like P4, pentium and other - don't remeber
> you could check intel dev manual for this).

 This is an error in some newer Intel documents -- the set of supported
bits is the same for all APICs implementing the ESR register and the error
interrupt (the 82489DX is the one to provide neither).

  Maciej
