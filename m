Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYFVVBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYFVVBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYFVVBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:01:30 -0400
Received: from [194.117.236.238] ([194.117.236.238]:46426 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbYFVVB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:01:29 -0400
Date: Mon, 23 Jun 2008 00:01:02 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, tzanussi@gmail.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Message-ID: <20080623000102.2e364974@linux360.ro>
In-Reply-To: <19f34abd0806221343o3a9e3951j1448e968f9ba9684@mail.gmail.com>
References: <20080621171051.5ed3b522@linux360.ro>
	<84144f020806221222s7498593ap7cad427405fb6776@mail.gmail.com>
	<20080622233848.50f14605@linux360.ro>
	<19f34abd0806221343o3a9e3951j1448e968f9ba9684@mail.gmail.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 22:43:55 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:
 
> By the way -- may I ask why it is called early_initcall() and not
> pre_smp_initcall()? I think it makes sense to encode the exact purpose
> of the initcall into the name. "early" is not very explicit. This is
> just my opinion :-) Thanks.

CPU hotplug docs name these (inexisting at that time) initcalls
'early', so I went on implementing 'early initcalls'. However, I don't
have strong feelings for either of these two names, so this could
change.

> Vegard
> 
