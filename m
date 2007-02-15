Return-Path: <linux-kernel-owner+w=401wt.eu-S1161472AbXBOWNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161472AbXBOWNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161469AbXBOWNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:13:07 -0500
Received: from ns2.suse.de ([195.135.220.15]:39377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161472AbXBOWNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:13:06 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 14:12:43 -0800
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142214.53625.agruen@suse.de> <200702152034.l1FKYS93012172@turing-police.cc.vt.edu>
In-Reply-To: <200702152034.l1FKYS93012172@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151412.43758.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 12:34, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 14 Feb 2007 22:14:53 PST, Andreas Gruenbacher said:
> > I agree, that's really what should happen. We solve this by marking
> > modules as supported, partner supported, or unsupported, but in an
> > "insecure" way, so partners and users could try to fake the support
> > status of a module and/or remove status flags from Oopses, and
> > cryptography wouldn't save us.
>
> Where cryptography *can* save you is that a partner or user can't fake a
> 'Suse Supported' signature without access to the Suse private key.

No question about that. We actually already get this from rpm signatures. What 
would module signatures buy us? The kernel could then reliably determine that 
an unsigned module was loaded. But people could still fake their Oopses, or 
overwite the flags which indicate that a module's signature didn't match, so 
we still wouldn't reliably get at that information.

Andreas
