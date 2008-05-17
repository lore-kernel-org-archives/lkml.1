Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYEQHq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYEQHq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYEQHqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:46:48 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:13144 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYEQHqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:46:47 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
Date: Sat, 17 May 2008 09:43:53 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>
References: <482C8595.5030509@garzik.org> <200805171628.03801.rusty@rustcorp.com.au> <20080517064307.GA16857@gondor.apana.org.au>
In-Reply-To: <20080517064307.GA16857@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805170943.54031.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 17. Mai 2008 schrieb Herbert Xu:
> On Sat, May 17, 2008 at 04:28:03PM +1000, Rusty Russell wrote:
> >
> > But you did not address the DoS question: can we ignore it?  Or are we 
trading 
> > off a DoS in the host against a potential security weakness in the guest?
> 
> Why not do both? Use the host's urandom to make the guest at least
> unpredictable on start-up without increasing the guest's entropy,
> and use the host's random to actually increase the guest's entropy.

I think the proper solution would be to use the hosts /dev/hw_rng - if 
available.
