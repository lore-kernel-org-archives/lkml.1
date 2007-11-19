Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbXKSPbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbXKSPbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXKSPbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:31:48 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51756 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754087AbXKSPbr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:31:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAHs7QUdMROHU/2dsb2JhbACQXQ
Date: Mon, 19 Nov 2007 10:31:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc-patch 0/9] Immediate Values for 2.6.24-rc2-git5
Message-ID: <20071119153139.GA24454@Krystal>
References: <20071116200238.740495156@polymtl.ca> <20071117125007.GA4450@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071117125007.GA4450@gollum.tnic>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:24:22 up 15 days, 20:29,  4 users,  load average: 3.75, 2.06,
	1.31
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Borislav Petkov (bbpetkov@yahoo.de) wrote:
> On Fri, Nov 16, 2007 at 03:02:38PM -0500, Mathieu Desnoyers wrote:
> Hi, 
> just a conventions proposal: have you thought of shortening all those
> "immediate_foo" prefixes to 'imm_foo', for example? This'll make the 
> code much more readable, i think.
> 

Hrm, a quick grep in the kernel tree shows me that the imm_* namespace
is already quite clobbered (although I do not detect any imm_read or
imm_set). Although I like the imm_ idea, I would like to make sure we do
not break any existing imm_read or imm_set users.

But since I don't see any, I think it would make sense.

> - 
> Regards/Gruß,
>     Boris.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
