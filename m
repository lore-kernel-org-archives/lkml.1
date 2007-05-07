Return-Path: <linux-kernel-owner+w=401wt.eu-S966820AbXEGUtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966820AbXEGUtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966811AbXEGUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:48:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62123 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966563AbXEGUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:48:52 -0400
Date: Mon, 7 May 2007 13:50:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
Message-Id: <20070507135052.cc7e74ca.randy.dunlap@oracle.com>
In-Reply-To: <463F8CB4.3040603@garzik.org>
References: <m3abwhcy74.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705070343330.2733@scrub.home>
	<m3tzupc6wz.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705071318150.1479@scrub.home>
	<m3r6psc0ee.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705071509290.1479@scrub.home>
	<463F27CE.2040008@garzik.org>
	<Pine.LNX.4.64.0705071538060.1479@scrub.home>
	<m3lkg0a88y.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705071901020.1479@scrub.home>
	<a781481a0705071115v5bce9382q166b9c0e0c52c6ef@mail.gmail.com>
	<463F8CB4.3040603@garzik.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2007 16:31:48 -0400 Jeff Garzik wrote:

> Satyam Sharma wrote:
> > Yes, mixing select and depends is a recipe for build disasters. Call
> > me a rabid fanatic, but I would in fact go as far as to say that this
> > whole "select" thing in the Kconfig process is one big BUG, and not a
> > feature. People are lazy by nature and would rather just "select" a
> > dependency for their config option than burden users with several
> > "depends".
> 
> Tough, the kernel community has voted against you.

Andrew (usually) implores people not to use "select" and I agree
with him.

> It makes far more sense to include a driver during kernel configuration, 
> and have that driver pull in its libraries via 'select'.  The lame 
> alternative requires developers to know which libraries they need BEFORE 
> picking their drivers, which is backwards and requires legwork on the 
> part of the kernel developer.

Developers?  If you had said "users," I might agree, but IMO it's
OK (or even Good) for developers to know what libraries their code
uses/requires.  Yes, that's a good thing.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
