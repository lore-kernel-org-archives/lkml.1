Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbXLHHjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbXLHHjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 02:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXLHHix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 02:38:53 -0500
Received: from main.gmane.org ([80.91.229.2]:55393 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbXLHHiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 02:38:52 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Date: Sat, 08 Dec 2007 02:38:32 -0500
Organization: World Organi[sz]ation Of Broken Dreams
Message-ID: <1197099477.20786.149.camel@perihelion>
References: <20071204165502.0a8f695e@the-village.bc.nu>
	 <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org>
	 <20071204204036.484f11ac@the-village.bc.nu>
	 <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com>
	 <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com>
	 <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com>
	 <20071205144934.GL7259@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: boston.jonmasters.org
In-Reply-To: <20071205144934.GL7259@thunk.org>
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-05 at 09:49 -0500, Theodore Tso wrote:
> On Wed, Dec 05, 2007 at 08:26:19AM -0600, Mike McGrath wrote:
> >
> > Ok, whats going on here is an issue with how the smolt RPM installs the 
> > UUID and how Fedora's Live CD does an install.  It's a complete false alarm 
> > on the kernel side, sorry for the confusion.
> 
> BTW, You may be better off using "uuidgen -t" to generate the UUID in
> the smolt RPM, since that will use 12 bits of randomness from
> /dev/random, plus the MAC, address and timestamp.  So even if there is
> zero randomness in /dev/random, and the time is January 1, 1970, at
> least the MAC will contribute some uniqueness to the UUID.

I haven't checked how uuidgen uses the MAC, but I would suggest that
that is not something Fedora should jump at doing - although it would
help ensure unique UUIDs, it also contributes to the tinfoil hat
responses that usually come up with things like smolt.

Jon.



