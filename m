Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbZFNPju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbZFNPju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZFNPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:39:43 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46446 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbZFNPjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:39:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18997.6590.427221.898997@pilspetsen.it.uu.se>
Date: Sun, 14 Jun 2009 17:39:42 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: crypt issue with 2.6.30/gcc 4.4.0?
In-Reply-To: <4A35159E.7080004@xs4all.nl>
References: <4A34FD06.2020204@xs4all.nl>
	<18997.5184.484019.744195@pilspetsen.it.uu.se>
	<4A35159E.7080004@xs4all.nl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel writes:
 > On 06/14/2009 05:16 PM, Mikael Pettersson wrote:
 > > Udo van den Heuvel writes:
 > >  > How can I find out what's the cause for the password issue?
 > > 
 > > Instead of changing two variables at once (kernel version AND gcc version)
 > > you keep one constant and vary the other.
 > > 
 > > IOW, rebuild 2.6.29.4 with gcc-4.4 and test.
 > > Then rebuild 2.6.30 with gcc-4.3 or older and test.
 > 
 > I can do the 2.6.29.4 build with gcc-4.4 but the gcc-4.3 case is harder
 > to do: I need to convince Fedora to install a 2nd compiler-version (and
 > rest of toolchain).

Not true. Just as you can choose from multiple self-built kernels
you can build and choose dynamically from multiple self-built GCCs.

E.g., for this particular case, download gcc-4.3.3.tar.bz2, tar jxf it,
mkdir objdir, cd objdir, /path/to/gcc-4.3.3/configure --prefix=/tmp/gcc43
--enable-languages=c, make, make install, cd /path/to/linux-2.6.30,
PATH=/tmp/gcc43/bin:$PATH make, and so on.
