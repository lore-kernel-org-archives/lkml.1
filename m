Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYFVUjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYFVUjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYFVUjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:39:47 -0400
Received: from [194.117.236.238] ([194.117.236.238]:34689 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbYFVUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:39:46 -0400
Date: Sun, 22 Jun 2008 23:38:48 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: tzanussi@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Message-ID: <20080622233848.50f14605@linux360.ro>
In-Reply-To: <84144f020806221222s7498593ap7cad427405fb6776@mail.gmail.com>
References: <20080621171051.5ed3b522@linux360.ro>
	<84144f020806221222s7498593ap7cad427405fb6776@mail.gmail.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 22:22:00 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi Eduard,

Hi,
 
> As there aren't that many functions called from do_pre_smp_initcalls()
> , I'd suggest you just go ahead and convert them to get this patch
> merged to mainline.

Will do, good idea. However, I feel like these should be two different
patches. The first adds the new interface, the second converts existing
users to the new interface. Will resubmit the patch series soon, along
with the conversion patch.


	Eduard
