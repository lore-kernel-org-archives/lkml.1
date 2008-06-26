Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbYFZSYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbYFZSYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbYFZSYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:24:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:34210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbYFZSYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:24:01 -0400
Date: Thu, 26 Jun 2008 20:23:58 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080626202358.13066e6b@kopernikus.site>
In-Reply-To: <4863D930.2040300@kernel.org>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de>
	<1214423826-12628-2-git-send-email-bwalle@suse.de>
	<20080625224301.GE32344@redhat.com>
	<18531.20387.111875.576837@harpo.it.uu.se>
	<20080626104524.2d7ed1ab@halley.suse.de>
	<18531.23894.572847.322265@harpo.it.uu.se>
	<4863D930.2040300@kernel.org>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
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

* "H. Peter Anvin" <hpa@kernel.org> [2008-06-26 11:00]:
> 
> Making this depend on KEXEC would be most unfortunate.  This is valuable 
> information for finding all kinds of issues even in the absence of KEXEC.
> 
> I really don't see a point in making this configurable, except perhaps 
> under CONFIG_EMBEDDED.

Now we have all opinions about how making that interface
configurable. Mikael, should an option under CONFIG_EMBEDDED be
acceptable for you?

Then I can repost the patch, Cc Greg KH and see if the sysfs structure
would be ok for him.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
