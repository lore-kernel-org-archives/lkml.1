Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbZGIN75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbZGIN75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760553AbZGIN7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:59:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58479 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759129AbZGIN7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:59:48 -0400
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
In-Reply-To: <20090709104228.7821e2f0@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	 <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	 <19026.38137.63807.427511@samba.org>
	 <200907072356.51553.Martin@lichtvoll.de>
	 <19028.3736.892828.352905@samba.org>
	 <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	 <19028.31088.400461.939917@samba.org>
	 <20090708130256.40957c3f@lxorguk.ukuu.org.uk>
	 <19028.39145.180869.603673@samba.org>
	 <20090708142510.5068b4c3@lxorguk.ukuu.org.uk>
	 <19029.17896.769106.375379@samba.org>
	 <20090709104228.7821e2f0@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 08:59:41 -0500
Message-Id: <1247147981.3898.15.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 10:42 +0100, Alan Cox wrote:
> > no, when the vendors are given a clearly non-infringing way of
> > implementation then I think they will go for it. The proof is that
> 
> Even if they go for the non-infringing tweak they will still end up with
> patches to rip out the potentially infringing code paths.

You keep saying this and I keep pointing out to you it's not true.

Vendors would only rip the code out if they truly feared a suit for
contributory infringement based on shipping the code.  I don't actually
believe that a compile time option they turn on in the binary kernel to
make it non infringing coupled with shipping code where the user could
recompile with it off is sufficient to rise to the tests under the
contributory infringement doctrine.

Even if I'm wrong on this, vendors still won't rip out the code in this
case principally because this is a weak set of patents they universally
regard as invalid.  The way to troll with a weak patent is to go after
the small fish (namely end users) who can't sustain a business shutdown
under TRO or ITU actions.

The point of this patch is to alter the code sufficiently to forestall
troll actions against small redistributors or end users, not to shield
vendors from contributory infringement suits which would never get filed
because the patents are too weak for such a large scale attack.

James


