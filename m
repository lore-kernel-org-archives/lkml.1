Return-Path: <linux-kernel-owner+w=401wt.eu-S1762611AbXJOWD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611AbXJOWD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbXJOWDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:03:19 -0400
Received: from mx1.suse.de ([195.135.220.2]:50221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536AbXJOWDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:03:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [stable] [PATCH 00/12] xen/paravirt_ops patches for 2.6.24
Date: Tue, 16 Oct 2007 00:03:12 +0200
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
References: <20071015204840.074767068@goop.org> <20071015215406.GA1588@kroah.com> <4713E2D6.90801@goop.org>
In-Reply-To: <4713E2D6.90801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160003.13189.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 12/12] xfs: eagerly remove vmap mappings to avoid
> upsetting Xen

This should be probably done unconditionally because it's a undefined
dangerous condition everywhere.

-Andi
