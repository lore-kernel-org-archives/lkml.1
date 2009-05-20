Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZETLdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZETLdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbZETLcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:32:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55329 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbZETLcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:32:14 -0400
Date: Wed, 20 May 2009 13:38:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Karsten Keil <keil@b1-systems.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design board to hfcmulti
Message-ID: <20090520113813.GE8684@one.firstfloor.org>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de> <81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de> <87y6ssnr5v.fsf@basil.nowhere.org> <200905201119.48782.keil@b1-systems.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905201119.48782.keil@b1-systems.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten,

> 
> This config is not set by mISDN, it is set by somepowerpc  sub arch.

That still seems like a rather quirky way to do this then, making
drivers dependent on specific architectures. This kind
of thing lead to ifdef jungles in the past, hopefully not done
again in new drivers.

Standard ways to handle this:
- If the driver needs something special only this architecture can
provide make the architecture set a special HAS... config option.
- Provide a special asm include file that is stubbed out
by other architectures.
- Put the arch specific code in another file and make that dependent on the 
HAS_...  symbol in the Makefile.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
