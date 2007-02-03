Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbXBCUSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbXBCUSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 15:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXBCUSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 15:18:04 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10364 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXBCUSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 15:18:03 -0500
Date: Sat, 3 Feb 2007 12:12:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag
 string termination trick
Message-Id: <20070203121249.1f90aa5e.randy.dunlap@oracle.com>
In-Reply-To: <20070203195607.1db92edd@localhost.localdomain>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
	<20070203081426.GA10520@flint.arm.linux.org.uk>
	<20070203195607.1db92edd@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 19:56:07 +0000 Alan wrote:

> On Sat, 3 Feb 2007 08:14:26 +0000
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > On Sat, Feb 03, 2007 at 03:08:14AM +0100, Bodo Eggert wrote:
> > > This patch changes the module license handling code to:
> > > - prevent the "GPL\0 for nothing"-trick
> > 
> > You can achieve this effect without changing the existing module
> > format, and it's far more difficult to bypass with build-with-
> > modified module.h tricks.
> 
> Nice, this should go in anyway.
> 
> Acked-by: Alan Cox <alan@redhat.com>

Yes, nice job.  Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

and Tested-by: :)

---
~Randy
