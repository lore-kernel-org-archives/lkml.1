Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYKILmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYKILmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYKILmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:42:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54141 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYKILmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:42:21 -0500
Date: Sun, 9 Nov 2008 20:41:12 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH] change CONFIG_NUMA description
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <4914BD77.2080005@redhat.com>
References: <20081106085301.GB4890@elte.hu> <4914BD77.2080005@redhat.com>
Message-Id: <20081109204031.F4FF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	  For 64-bit this is recommended if the system is Intel Core 7i
> > +	  (or later), AMD Opteron, or EM64T NUMA.
> > +
> > +	  For 32-bit this is only needed on (rare) 32-bit-only platforms
> > +	  that support NUMA topologies, such as NUMAQ / Summit, or if you
> > +	  boot a 32-bit kernel on a 64-bit NUMA platform.
> > +
> > +	  Otherwise, you should say N.
> >  
> >  comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
> >  	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
> 
> Core i7, not Core 7i.

Good catch.
Tanks.



