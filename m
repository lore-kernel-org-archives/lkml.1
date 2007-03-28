Return-Path: <linux-kernel-owner+w=401wt.eu-S965751AbXC1UPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbXC1UPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965752AbXC1UPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:15:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:48645 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965751AbXC1UO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:14:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Clean up mach_reboot_fixups
Date: Wed, 28 Mar 2007 22:14:51 +0200
User-Agent: KMail/1.9.5
Cc: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Stephane Eranian <eranian@hpl.hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46099709.2000304@goop.org> <200703282154.04245.ak@suse.de> <460ACC05.4020401@goop.org>
In-Reply-To: <460ACC05.4020401@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282214.52612.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 22:11, Jeremy Fitzhardinge wrote:
> Two cleanups:
>  - reboot_fixups.h is entirely i386-dependent, so put it in asm-i386
>  - use a weak version rather than ifdeffery
> 
> [ Andi - the machine_ops probably depends on this, but only in a minor
>   context-clash way. ]

Sorry I actually had it already, but forgot about it

-Andi
