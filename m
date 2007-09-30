Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbXI3Tr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbXI3Tr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXI3TrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:47:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54123 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXI3TrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:47:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc8-mm2
Date: Sun, 30 Sep 2007 22:01:43 +0200
User-Agent: KMail/1.9.5
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <18268.1191119181@turing-police.cc.vt.edu> <20070930015014.78bb88d3.akpm@linux-foundation.org>
In-Reply-To: <20070930015014.78bb88d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709302201.44146.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 September 2007 10:50, Andrew Morton wrote:
> On Sat, 29 Sep 2007 22:26:21 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Thu, 27 Sep 2007 02:22:20 PDT, Andrew Morton said:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> > 
> > Locks up hard at very early boot on my Dell Latitude - grub says loading
> > kernel, the screen clears, and we lock up before we get penguins.
> > 
> > -rc8-mm1 was OK. I'm off to go bisect, figured I'd drop a heads-up.
> > 
> 
> It doesn't ring a bell, sorry.  hpet-force-enable-on-ich34.patch is known
> to be bad, but it causes failure later in the boot than that.

http://lkml.org/lkml/2007/9/27/322, perhaps?
