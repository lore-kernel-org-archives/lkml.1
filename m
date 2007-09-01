Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXIAO2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXIAO2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 10:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbXIAO2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 10:28:03 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45233 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbXIAO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 10:27:53 -0400
Message-ID: <46D976D0.7030208@s5r6.in-berlin.de>
Date: Sat, 01 Sep 2007 16:27:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <Pine.LNX.4.64.0709010648530.32589@localhost.localdomain> <46D947A3.1000404@garzik.org> <200709011544.07732.bzolnier@gmail.com>
In-Reply-To: <200709011544.07732.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
...
> Part of the problem is that many people (including developers) learn about
> things being deprecated/obsoleted after they are actually removed.
> 
> Of course things are not black and white and common sense is required but
> moving in the Kconfig direction is an improvement IMO and could speed up
> the development in the long-term.
...

I basically agree.  Most people use precompiled kernel packages though.
For them we add kernel log messages, for example.  We also preemptively
get in touch with user mailinglists and the like, but we reach only a
fraction of affected people there either.

For people who actually compile kernels, especially distributors, it
would indeed be helpful if "make oldconfig" and Co. show a prompt if an
option entered feature removal schedule.  Actually this has been done
before for things like particular sysfs changes, with ad-hoc CONFIG_
variables.
-- 
Stefan Richter
-=====-=-=== =--= ----=
http://arcgraph.de/sr/
