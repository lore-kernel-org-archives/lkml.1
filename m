Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbXFPJCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbXFPJCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 05:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbXFPJCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 05:02:25 -0400
Received: from 1wt.eu ([62.212.114.60]:3015 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbXFPJCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 05:02:24 -0400
Date: Sat, 16 Jun 2007 11:02:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux Servers comparison with Windows 2003 servers for Gaming
Message-ID: <20070616090217.GV943@1wt.eu>
References: <8d6898730706150712u182f5af1h2d92030adf16d022@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6898730706150712u182f5af1h2d92030adf16d022@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 07:42:50PM +0530, Nobin Mathew wrote:
> I am trying to move my Game server from windows to Linux.
> 
> Is this a good idea?
> How much better performance i will get?
> 
> Can i fine tune the 2.6.20 kernel to get better performance?
> What all areas i can do this fine tuning?
> 
> what other things i can do to get better performance?

All this depends a lot on your workload. If you're CPU-bound, maybe it
will not change anything. If you're doing a lot of disk accesses, the
choice of the filesystem will be far more important than any config
option you might change. If you're doing a lot of network traffic, you
might consider not loading every unneeded network subsystem (ipv6,
netfilter, bridging, ...) to save CPU cycles, though it does not seem
to be your problem given your other mail indicating a 100 Mbps NIC.

If you don't know what limits your application, it is possible that
you will first run it with "standard" parameters (defaults from your
distro), and later reinstall it differently once you have measured
it usage.

Willy

