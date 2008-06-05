Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbYFEM6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbYFEM6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbYFEM6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:58:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53599 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757469AbYFEM6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:58:06 -0400
Date: Thu, 5 Jun 2008 13:42:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Olaf Hering <olaf@aepfle.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5
Message-ID: <20080605134222.76e117a4@core>
In-Reply-To: <20080605112436.GA4533@aepfle.de>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
	<20080605112436.GA4533@aepfle.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 13:24:36 +0200
Olaf Hering <olaf@aepfle.de> wrote:

> On Wed, Jun 04, Linus Torvalds wrote:
> 
> > Another week, another batch of mostly pretty small fixes. Hopefully the 
> > regression list is shrinking, and we've fixed at least a couple of the 
> > oopses on Arjan's list.
> 
> SATA on a dualcore G5 is broken, it happend between

See the patch I just posted to Nick/Jeff should fix it. I always said
ata_sff_check_status() was asking for trouble as a name and neither I nor
Jeff nor Linus noticed the bug...
