Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXIRC3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXIRC3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 22:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXIRC3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 22:29:07 -0400
Received: from [209.180.55.243] ([209.180.55.243]:53639 "EHLO
	jdub.homelinux.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbXIRC3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 22:29:06 -0400
X-Greylist: delayed 2535 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 22:29:06 EDT
Date: Mon, 17 Sep 2007 20:46:25 -0500
From: Josh Boyer <jwboyer@jdub.homelinux.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Satyam Sharma <satyam@infradead.org>, linuxppc-dev@ozlabs.org,
       Linux@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Mailing List <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc: Avoid pointless WARN_ON(irqs_disabled()) from
 panic codepath
Message-ID: <20070917204625.64b97392@vader.jdub.homelinux.org>
In-Reply-To: <20070917183749.fd690505.randy.dunlap@oracle.com>
References: <46EA5CEB.7020104@linux.vnet.ibm.com>
	<a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
	<alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
	<20070917183749.fd690505.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 18:37:49 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 18 Sep 2007 05:13:40 +0530 (IST) Satyam Sharma wrote:
> 
> > Untested (not even compile-tested) patch.
> > Could someone point me to ppc32/64 cross-compilers for i386?
> 
> OSDL had some, but those are gone now.
> I downloaded all of them and still use them, although it would
> be good to have some more recent versions of them.
> 
> I put the power* compiler tarballs here:
> 
> http://userweb.kernel.org/~rdunlap/cross-compilers/

Crosstool is widely used.  It'll build several combinations of
gcc/binutils/glibc for you.  

http://www.kegel.com/crosstool/

There's also the ELDK from Denx:  

http://www.denx.de/en/view/Software/WebHome#Embedded_Linux_Development_Kit

josh
