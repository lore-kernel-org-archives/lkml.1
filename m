Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYGPJJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYGPJJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYGPJJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:09:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:33816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYGPJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:09:44 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied
	from	in-kernel, use it in more drivers.
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <487D660A.6090504@garzik.org>
References: <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	 <1216150616.27455.377.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
	 <1216151640.27242.90.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm>
	 <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm>
	 <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org>
	 <20080716005133.GK8185@mit.edu> <20080716013619.GD17417@redhat.com>
	 <487D660A.6090504@garzik.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 11:09:07 +0200
Message-Id: <1216199347.5232.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 23:07 -0400, Jeff Garzik wrote:
> Dave Jones wrote:
> > Whilst it would be great for unified development on the tools that
> > create the early boot process, I think it's a non-starter due to the
> > fact that you can't really do it without throwing out everything you
> > already have today.  The same reason imo, that hpa's klibc work hasn't
> > gained mass-appeal from vendors.
> 
> Quite true and IMO disappointing, because klibc would make great 
> infrastructure for rolling out things just like this.

Indeed, for one i've been told it would enable cross compiling of
initrds, without which I deem initrd useless junk - whoever still
compiles their kernel on the machine it will run on? :-)



