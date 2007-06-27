Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXF0Mjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXF0Mjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760677AbXF0Mj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:39:28 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:35933 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbXF0Mj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:39:26 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Question about fair schedulers
Date: Wed, 27 Jun 2007 14:39:20 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <B6065113-E9C7-42CE-A43D-55E6BF1EE2C0@mac.com>
In-Reply-To: <B6065113-E9C7-42CE-A43D-55E6BF1EE2C0@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271439.21043.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Kyle Moffett wrote:
> On Jun 22, 2007, at 18:07:15, Alberto Gonzalez wrote:
> > P.S: As a second thought, a fair scheduler could behave really good
> > in other scenarios, like a server running a busy forum on apache
> > +mysql+php. Besides, this is a more real world scenario (and easier
> > to benchmark). Why aren't people testing these schedulers under
> > this kind of load?
>
> That kind of load is boring precisely because it doesn't care about
> interactivity.  CFS/SD aren't a whole lot different from mainline-
> without-interactivity in that respect, precisely because the latency
> of the network is between ten and a hundred times more than the
> latency of the scheduler.  The only time it really matters is with
> desktops where users care about smoothness.

Well, I've just seen some benchmarks of this kind with CFS and it does make a 
difference. The scalability problem with MySQL seems to get solved with this 
scheduler. However, the peak throughput is quite lower than with the same 
kernel/glibc version and mainline scheduler.

http://jeffr-tech.livejournal.com/

Anyway, this kind of testing seems to be useful. Linux is too widely deployed 
in servers to ignore the behavior of a CPU scheduler in that scenario.

Cheers,
Alberto.
