Return-Path: <linux-kernel-owner+w=401wt.eu-S936304AbXGMJTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936304AbXGMJTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbXGMJTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:19:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:7857 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867AbXGMJTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:19:31 -0400
Date: Fri, 13 Jul 2007 11:19:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <4696FC43.3000201@goop.org>
Message-ID: <Pine.LNX.4.64.0707131114390.25352@fbirervta.pbzchgretzou.qr>
References: <200707111916.35036.jesper.juhl@gmail.com> 
 <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> 
 <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com> 
 <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com>
 <4696FC43.3000201@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 12 2007 21:14, Jeremy Fitzhardinge wrote:
>
> Well, smaller stacks are better where possible, but there's nothing magic about
> 4k.

There is. It is exactly one page on x86. I cannot remember who said it when,
but anything greater than a page implies some penalty.

> Sure, its mostly enough, but there's no particular reason to believe it
> will be enough for everything.  You could state a priori that all kernel
> code paths must fit into 4k of stack, but that's pretty arbitrary.

	Jan
-- 
