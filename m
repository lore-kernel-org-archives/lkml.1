Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYFVUAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYFVUAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYFVT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:59:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:44015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbYFVT74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:59:56 -0400
Date: Sun, 22 Jun 2008 21:59:53 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Introduce userspace interface for Firmware-provided memory map
Message-ID: <20080622215953.214419b0@kopernikus.site>
In-Reply-To: <485C149E.1000807@kernel.org>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
	<20080620194200.GC21235@redhat.com>
	<485C149E.1000807@kernel.org>
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

Hi,

* "H. Peter Anvin" <hpa@kernel.org> [2008-06-20 13:35]:
>
> Vivek Goyal wrote:
> > On Fri, Jun 20, 2008 at 05:56:57PM +0200, Bernhard Walle wrote:
> >> This patch (as request for comments) introduces a new userspace interface
> >> /proc/firmware_mem that provides the unfiltered view of the BIOS on
> >> memory configuration. That's usable for two reasons:
> > 
> > How about /proc/firmware_memmap. This is little longish but probably more
> > clear in intent.
> 
> Perhaps even /proc/firmware/memmap (or /sys/firmware/memmap/...).  I 
> realize introducing a new directory is annoying, but it's a namespace 
> that is likely to have other users.

Since /sys/firmware is already used by ACPI and EDD, I think that's
quite a good idea! Maybe we should also export the raw E820 or EFI
memory map there. Just like EDD.

I'll send a new patch.




Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
