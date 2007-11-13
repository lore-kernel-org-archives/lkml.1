Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbXKMXxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbXKMXxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbXKMXxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:53:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbXKMXxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:53:38 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
Date: Wed, 14 Nov 2007 00:53:33 +0100
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
References: <20071015204840.074767068@goop.org> <4713E2D6.90801@goop.org> <20071113232258.GA10338@kroah.com>
In-Reply-To: <20071113232258.GA10338@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140053.33584.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Subject: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid
> > upsetting Xen

This patch was the wrong fix anyways as discussed; David Chinner
finally came up with a better one.

-Andi

