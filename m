Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYGVSWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYGVSWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYGVSWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:22:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45709 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752605AbYGVSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:22:37 -0400
Date: Tue, 22 Jul 2008 19:05:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: Firmware breakage
Message-ID: <20080722190516.4ee477f4@lxorguk.ukuu.org.uk>
In-Reply-To: <1216748431.3019.6.camel@shinybook.infradead.org>
References: <20080722173420.6f90556d@lxorguk.ukuu.org.uk>
	<1216748431.3019.6.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 13:40:31 -0400
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2008-07-22 at 17:34 +0100, Alan Cox wrote:
> > If you crossbuild x86-32 on x86-64 and then attempt to do the install on
> > an x86-32 box the install now breaks. This used to work until the
> > firmware changes. Now you get
> > 
> > /bin/sh: scripts/basic/fixdep: cannot execute binary file
> > 
> > Fixdep should be built for the target platform surely ?
> 
> Er, I haven't knowingly touched anything involving fixdep. Can you show
> me exactly what you did? I'll try to reproduce and understand what's
> happening.

Build on a 64bit box with ARCH=i386
NFS mount on a 32bit box
make modules_install on 32bit box

It used to work nicely, as of the firmware changes it doesn't. Not sure
what the trigger is here yet.

If I hand rebuild fixdep as a 32bit binary the rest runs through fine.



