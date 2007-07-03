Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbXGCLpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbXGCLpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbXGCLpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:45:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:55717 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbXGCLpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:45:45 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-pm@lists.linux-foundation.org,
       nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707031327.56577.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031307.41366.oliver@neukum.org>
	 <E1I5gSu-0003f4-00@dorka.pomaz.szeredi.hu>
	 <200707031327.56577.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 21:45:12 +1000
Message-Id: <1183463113.10386.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 13:27 +0200, Oliver Neukum wrote:
> > You are talking about hibernate, right?  Suspending (to ram) is
> > instantaneous, in that _after_ suspend no CPU is active obviously.
> 
> If that is so, why do you care? If it is really atomic, fuse has no
> chance
> to call out to its component in user space either. Removing the
> freezer
> cannot make a difference.

It's not atomic. You will get called after suspend() in drivers. The
thing is ... you just have to deal with it :-)

Ben.


