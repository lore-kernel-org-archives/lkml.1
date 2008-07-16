Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYGPBnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYGPBnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYGPBnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:43:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYGPBnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:43:21 -0400
Date: Tue, 15 Jul 2008 21:36:19 -0400
From: Dave Jones <davej@redhat.com>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080716013619.GD17417@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
	Marcel Holtmann <marcel@holtmann.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org
References: <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150616.27455.377.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org> <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <20080716005133.GK8185@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716005133.GK8185@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 08:51:33PM -0400, Theodore Tso wrote:
 > For one reason, because there's more than one mkinitrd.  FC9 ships
 > with mkinitrd 6.0.52; OpenSuSE ships with mkinitrd 2.1, and the
 > sources don't look even vaguely similar to one another.

Right. Other than name, they've historically shared nothing.
Both have grown through the evolution of multiple distros, requiring
different workarounds in each due to differences in CONFIG_ options
in the kernel between vendors for eg.

Whilst it would be great for unified development on the tools that
create the early boot process, I think it's a non-starter due to the
fact that you can't really do it without throwing out everything you
already have today.  The same reason imo, that hpa's klibc work hasn't
gained mass-appeal from vendors.

Even if we had a 'reference' mkinitrd in the kernel, it would be pretty much
useless until it reached feature parity with every distros existing tools,
and if everyone uses those instead of furthering the reference implementation,
it fails on the starting blocks.

	Dave

-- 
http://www.codemonkey.org.uk
