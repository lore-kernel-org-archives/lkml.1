Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZF3Oe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZF3Oe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZF3OeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:34:18 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:51208 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753196AbZF3OeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:34:17 -0400
Date: Tue, 30 Jun 2009 10:32:46 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0906301030260.6124@gentwo.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>  <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>  <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com> <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Pekka Enberg wrote:

> Well, I obviously don't agree here because kmalloc-4096 debugging causes
> problems in the real world. Furthermore, SLUB never supported debugging
> for objects that big historically because of page allocator passthrough.
> And with Mel Gorman's page allocator optimizations, we might be going
> back to that.

SLUB for some period of time had passthrough. It did not start out like
that though.

kmalloc-4096 causes problems in the long run and so do other caches that
are of similar size. But it allows debugging to occur. Silently switching
it off is something I am not comfortable with.

