Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0CKNeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:34:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37411 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab0CKNeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:34:10 -0500
Date: Thu, 11 Mar 2010 13:33:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: dave b <db.pub.mail@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
Message-ID: <20100311133353.GC25011@n2100.arm.linux.org.uk>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com> <19346.6765.457769.167118@pilspetsen.it.uu.se> <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 09:24:49PM +1100, dave b wrote:
> I had already reported it to debian -
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=572653
> 
> I have cc'ed linux-arm-kernel into this email.

I think most of the points have already been convered, but just for
completeness,

What is the history of the hardware you're running these builds on?
Has it proven itself on previous kernel versions running much the same
tests?

Another point to consider: how are you running the compiler - is it
over NFS from a PC?

The reason I ask is that you can suffer from very weird corruption
issues - I have a nice illustration of one which takes a copy of 1GB
worth of data each day, and every once in a while, bytes 8-15 of a
naturally aligned 16 byte block in the data become corrupted somewhere
between the network and disk.  The probability of corruption happening
is around 0.0000001%, but it still happens... and that makes it
extremely difficult to track down.
