Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbYGOW1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbYGOW1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYGOW1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:27:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYGOW1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:27:03 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	 <1216150616.27455.377.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
	 <1216151640.27242.90.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm>
	 <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:26:25 -0700
Message-Id: <1216160785.26991.51.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 15:24 -0700, david@lang.hm wrote:
> 
> > Why is it suddenly so important that a kernel be 'zero impact' for that
> > module case, when it's never been zero impact for that case before? You
> > had to rewrite the initrd to begin with, but now you're not willing to do
> > it again, just because you have to rewrite it slightly _differently_?
> 
> becouse the tools that wrote the initrd already put the modules in. I 
> don't maintain those tools, they came with the distro. we're just asking 
> to not require those tools to be updated immediatly.

The tools that write the initrd already put the firmware in too.

-- 
dwmw2

