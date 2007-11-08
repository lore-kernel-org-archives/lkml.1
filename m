Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbXKHBgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbXKHBgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXKHBg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:36:29 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37887 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039AbXKHBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:36:29 -0500
Date: Thu, 8 Nov 2007 02:36:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: ciol <ciol13@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071108013605.GD26163@stusta.de>
References: <fgtfqa$h9j$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fgtfqa$h9j$1@ger.gmane.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 11:56:57PM +0100, ciol wrote:
> Hi, I'd like to ask you a few questions:
>
> * Do you like the way linux distributions integrate the kernel?
>
> * Wouldn't you prefer they ship with the stable and still maintained 
> 2.6.16.X, while providing optionally the latest kernel for those who want 
> or just have a new hardware?

No.

With 2.6.16 "new hardware" roughly equals to "sold during the
last 2-3 years", so most users would be forced to use this "option".

"providing optionally the latest kernel" would be a horror to support 
for a distribution.

>From all I hear all big distributions spend 3-6 months of QA work 
between pushing a kernel into the development branch of their 
distribution and putting it into a release.

They can't do this work for 4-6 different upstream kernels each year.

And if they'd omit it, their custumers would both blame them for 
shipping such a buggy distribution and swamp their support with bug
reports.

> * Do you think the megafreeze development model [1] and the "I don't trust 
> in upstream" development model are broken? (And why)
>...

Definitely not.

If your "stable base system" contains the kernel you lose the hardware 
support for recent hardware.

What should be more important for users than having their hardware 
supported?

And although it's off-topic for linux-kernel, your suggested 
"well-maintained additional package collections" also sound horrific:

As an example, consider the following:
- a new version of GNOME might require a new version of GTK+
- recently GTK+ 2.12 entered Debian testing, and this new version
  exposed a serious bug in the xfwm4 package that was at that time
  in testing

There are at least two obvious problems with what you propose:
- for avoiding breakages for users a huge amount of coordination
  work between the "additional package collections" would be required
- most users want their software to work correctly, not crash, etc.
  when a distribution has a 2-3 months freeze before a release that's 
  not lost time, that's time where _all_ software that will be shipped 
  gets tested and bugs fixed

There's one important thing you must have in mind:
Geeks (like you and me) can get the latest software versions from the 
development versions of their distribution, but for most users - for 
whom a computer is a tool that should simply work (no matter whether 
it's a server or a desktop) and not a toy - the QA work done during a 
freeze has a _huge_ value.

Fedora, openSUSE and Ubuntu all offer new releases every 6 months, which 
results in the software in the latest release always being less than
1 year old plus the user getting the QA work and the resulting stability 
of a freeze. This seems to be a good solution for desktop user.

cu
Adrian (2.6.16 maintainer)

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

