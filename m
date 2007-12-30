Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbXL3Rms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbXL3Rms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXL3Rml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:42:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:47472 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750945AbXL3Rml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:42:41 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18el2hdRYwe79OPxEuVLw1+F3INEJbETO7ocd+xX6
	18OIeNZU4tEW2P
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071230140815.GA27858@elte.hu>
References: <1198745736.4235.23.camel@homer.simson.net>
	 <1198779574.4425.50.camel@homer.simson.net>
	 <20071230140456.GJ16946@elte.hu>  <20071230140815.GA27858@elte.hu>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 18:42:34 +0100
Message-Id: <1199036554.4170.9.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-30 at 15:08 +0100, Ingo Molnar wrote:
> > ok, i prefer this fix a bit more. (we dont want to set last_tsc 
> > outside of the sync_lock - which your initial patch does)
> 
> i've added your patch to x86.git - thanks Mike! (patch below) I think 
> this would be too dangerous for v2.6.24 though - we can put it back into 
> -stable for 2.6.24.1, once it had more testing?

Methinks it's about as low a priority as exists.  Google returned me and
one other fellow...

	-Mike

