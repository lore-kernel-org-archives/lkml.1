Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYG3UOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYG3UOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYG3UO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:14:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbYG3UO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:14:27 -0400
Date: Wed, 30 Jul 2008 22:14:24 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH 2/2] firmware/memmap: Move kobject initialisation before
 kobject_add()
Message-ID: <20080730221424.0d997fb0@kopernikus.site>
In-Reply-To: <1217448752-13859-3-git-send-email-bwalle@suse.de>
References: <1217448752-13859-1-git-send-email-bwalle@suse.de>
	<1217448752-13859-3-git-send-email-bwalle@suse.de>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bernhard Walle <bwalle@suse.de> [2008-07-30 22:12]:
>
> Because kobject_init() call could be done from firmware_map_add_entry()
> which is called before kmalloc() can be used (we use the early bootmem allocator
> here), move that call to memmap_init() which is a late_initcall.

You can leave out that patch now since kobject_init() was adapted with
the other patch ... But I think it would still make sense to include
that one.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
