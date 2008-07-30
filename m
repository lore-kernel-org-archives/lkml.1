Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYG3UrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYG3UrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYG3UrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:47:12 -0400
Received: from mail.suse.de ([195.135.220.2]:50875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYG3UrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:47:10 -0400
Date: Wed, 30 Jul 2008 22:47:07 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, vgoyal@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH 2/2] firmware/memmap: Move kobject initialisation before
 kobject_add()
Message-ID: <20080730224707.6b0791b2@kopernikus.site>
In-Reply-To: <20080730134011.24d10dfe.akpm@linux-foundation.org>
References: <1217448752-13859-1-git-send-email-bwalle@suse.de>
	<1217448752-13859-3-git-send-email-bwalle@suse.de>
	<20080730221424.0d997fb0@kopernikus.site>
	<20080730134011.24d10dfe.akpm@linux-foundation.org>
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

* Andrew Morton <akpm@linux-foundation.org> [2008-07-30 13:40]:
>
> If you think that "firmware/memmap: Move kobject initialisation before
> kobject_add()" 

Yes, that's what I meant.

> should still be applied then I'd disagree. Adding a
> GFP_KERNEL allocation into kobject_init() was a fairly significant
> backward step.  It's _good_ that kobject_init() can be called this
> early.  Let us strive to retain that robustness.

Ok, since you have more experience with kobject, I'm fine with not
applying that one.

[I saw you merged the first (coding style) patch.]


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
