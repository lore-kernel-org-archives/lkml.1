Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXK1WoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXK1WoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbXK1WoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:44:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994AbXK1WoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:44:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andres Freund <andres@anarazel.de>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: "hwcap 0 nosegneg" doesnt work with paravirt_ops xen as of 2.6.23.9
In-Reply-To: Jeremy Fitzhardinge's message of  Wednesday, 28 November 2007 10:12:08 -0800 <474DAF78.8040300@goop.org>
References: <200711281829.25532.andres@anarazel.de>
	<474DAF78.8040300@goop.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071128224359.2B5CA26F8E7@magilla.localdomain>
Date: Wed, 28 Nov 2007 14:43:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > /etc/ld.so.conf.d/xen.conf:
> > hwcap 0 nosegneg
> 
> This looks OK. [...]

No, it does not match this:

	/* Bit used for the pseudo-hwcap for non-negative segments.  We use
	   bit 1 to avoid bugs in some versions of glibc when bit 0 is
	   used; the choice is otherwise arbitrary. */
	#define VDSO_NOTE_NONEGSEG_BIT	1

You really want "hwcap 1 nosegneg" given that.
Yes, we've been over this several times already.


Thanks,
Roland
