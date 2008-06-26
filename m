Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYFZIVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYFZIVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbYFZIVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:21:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884AbYFZIU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:20:59 -0400
Date: Thu, 26 Jun 2008 10:21:37 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Pavel Machek <pavel@suse.cz>
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/3] Use /proc/firmware_mem for x86 (e820)
Message-ID: <20080626102137.53cb95ad@halley.suse.de>
In-Reply-To: <20080624182817.GI5642@ucw.cz>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
	<1213977420-1555-3-git-send-email-bwalle@suse.de>
	<20080624182817.GI5642@ucw.cz>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
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

* Pavel Machek [2008-06-24 20:28]:
>
> > This patch copies the E820 map very early, before the kernel applies various
> > operations. That copy is used later to register only the BIOS-provided E820
> > map later in the resource tree for /proc/firmware_mem.
> 
> It is not process related -> it should not go to /proc. Talk to Greg.

http://lkml.org/lkml/2008/6/26/75


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
