Return-Path: <linux-kernel-owner+w=401wt.eu-S1030494AbXBTWRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030494AbXBTWRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030214AbXBTWRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:17:22 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:39938 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030193AbXBTWRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:17:21 -0500
Date: Tue, 20 Feb 2007 23:17:20 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Rick Jones <rick.jones2@hp.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking  UDPv4 recvfrom() taking 4usec @ 3GHz?
Message-ID: <20070220221719.GA16263@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Rick Jones <rick.jones2@hp.com>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
	Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070219231447.GA4400@outpost.ds9a.nl> <p73d545drx6.fsf@bingen.suse.de> <20070220162714.GA3245@outpost.ds9a.nl> <20070220164124.GA24930@2ka.mipt.ru> <20070220184242.GA30077@filer.fsl.cs.sunysb.edu> <20070220184859.GA1949@2ka.mipt.ru> <20070220193319.GA8800@outpost.ds9a.nl> <45DB6FD8.4050106@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DB6FD8.4050106@hp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 02:02:00PM -0800, Rick Jones wrote:

> The slope appears to be flattening-out the farther out to the right it 
> goes.  Perhaps that is the length of time it takes to take all the 
> requisite cache misses.

The rate of flattening out appears to correlate with the number of processes
running, even though the system is otherwise >99.5% idle during my
measurements.

With only 'gdm' running, things flatten out slowly, iow, it takes longer
delays to see recvfrom slow down. With only 1 process running (init=bash),
the graph is nearly flat.

>From this, it is probable that even an idle GNOME desktop (Ubunty Edgy Eft)
is under fierce cache pressure, enough to blow away my meagre 1MB in a
matter of milliseconds.

I'm trying to figure out which processes have the most impact, I had already
killed anything non-essential. But that still leaves 140 pids.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
