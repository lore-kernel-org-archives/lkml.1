Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZCDTeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZCDTeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZCDTeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:34:09 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:60563 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbZCDTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:34:08 -0500
Message-ID: <49AED7A7.9030304@codemonkey.ws>
Date: Wed, 04 Mar 2009 13:33:59 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org>	<200902282309.07576.nickpiggin@yahoo.com.au> <49AB19E1.4050604@goop.org> <49AED092.5080902@codemonkey.ws> <49AED391.1030500@zytor.com>
In-Reply-To: <49AED391.1030500@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> In particular, Xen is a microkernel-type operating system.  The dom0 
> model is a classic single-server, in the style of Mach.  A lot of the 
> "Xen could use a distributed dom0" arguments were also done with Mach 
> ("the real goal is a multi-server") but such a system never 
> materialized (Hurd was supposed to be one.)  Building multiservers is 
> *hard*, and building multiservers which don't suck is even harder.

A lot of the core Xen concepts (domains, event channels, etc.) were 
present in the Nemesis[1] exo-kernel project.

Two other interest papers on the subject "Are virtual machine monitors 
microkernels done right?"[2] from the Xen folks and a rebuttal from the 
l4ka group[3].

[1] http://www.cl.cam.ac.uk/research/srg/netos/old-projects/nemesis/
[2] http://portal.acm.org/citation.cfm?id=1251124
[3] http://l4ka.org/publications/paper.php?docid=2189

Regards,

Anthony Liguori
>     -hpa

