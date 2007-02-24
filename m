Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbXBXLNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbXBXLNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXBXLNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:13:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57791 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXBXLNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:13:23 -0500
Date: Sat, 24 Feb 2007 03:09:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew" <andrew@nelless.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
Message-Id: <20070224030950.074f88d4.akpm@linux-foundation.org>
In-Reply-To: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 13:35:50 -0000 (GMT) "Andrew" <andrew@nelless.net> wrote:
> Hi,
> 
> 2.6.21-rc1 fails to boot on my machine. As soon as I switch
> from grub the screen turns and remains black with no sign
> of Tux or any output.
> 
> I've run a git-bisect between 2.6.20 (which works fine) and
> 2.6.21-rc1 and found the first bad commit to be
> #59b8175c771040afcd4ad67022b0cc80c216b866 which seems bizarre
> to me since this is a mostly an ARM commit.
> 
> I haven't tried to revert this commit because frankly I don't
> know where to go from there with a multi-parent commit.
> 
> I'm running on on a Asus A8N-VM CSM motherboard with a single
> core AMD64 processor, with a nVidia GPU in the PCI-ex slot
> using the standard VESA frame buffer driver.
> 
> Relevant config's can be found here:
> http://homepage.ntlworld.com/anelless/linux/2.6.21-rc1/
> 

and, later,

> I have just discovered 2.6.21-rc1 boots with
> pci=noacpi ...

Presumably this regression was caused by the ACPI merge.  Are you able to
capture the dmesg output from the 2.6.20-rc1 boot?  netconsole might be
useful here, thanks.

(You get added to the post-2.6.20 regression list, so you'll be hearing
from us quite a lot for the next month.  Sorry ;))
