Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXBKVwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXBKVwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932565AbXBKVwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:52:22 -0500
Received: from 1wt.eu ([62.212.114.60]:2360 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXBKVwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:52:22 -0500
Date: Sun, 11 Feb 2007 22:52:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211215211.GB13913@1wt.eu>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no> <fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no> <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no> <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no> <fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no> <45CF60F2.5020308@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CF60F2.5020308@shaw.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 12:31:14PM -0600, Robert Hancock wrote:
> Willy Tarreau wrote:
> >Nigel, don't take it as a personal offense, but I think it is a very
> >centric view of Linux usages. Where I work, Linux is used a lot on
> >servers and appliances. It is used for mail relays, HTTP proxies,
> >anti-viruses, firewalls, routers, load balancers, UTM, SSH relays,
> >etc... Nobody would ever want to enable power management on those
> >machines, let alone suspend which would cause a major havoc, would
> >the system decide to enter suspend for any reason.
> >
> >Many people also have Linux on their notebooks, but as a dual-boot. You
> >read the word ? "dual-boot". It means that they cleanly shutdown their
> >system every time they don't use it anymore, and they won't know what
> >OS they'll use next time.
> >
> >I've never heard anyone there complaining "oh, I'm fed up with this
> >boring boot, I always have to wait 30 seconds when I need to do
> >something, I wish I could suspend and resume". It is considered the
> >normal way of using their PCs.
> 
> I think your experience is rather different than that of Joe Average 
> User who doesn't frequent kernel lists, and also I think you'll find 
> that for a lot of Linux laptop users that don't use supend, the reason 
> is that it doesn't work reliably, quite often due to driver issues.

I would believe it if I knew people using suspend/resume on the other OS.
But that's not the case either. Also, it happens that with today's RAM
sizes, suspend-to-disk then resume can be several times slower than a
clean fresh boot. When you have 1 GB to write at 20 MB/s, it takes 50
seconds to shut down, and as much to restart. Compare this to 5-10
seconds for a shutdown and 30-50 seconds for a cold boot, and it might
give you another clue why there are people not interested in such a
feature.

Regards,
Willy

