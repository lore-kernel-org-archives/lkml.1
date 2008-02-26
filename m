Return-Path: <linux-kernel-owner+w=401wt.eu-S1764204AbYBZX45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764204AbYBZX45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYBZX4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:56:48 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:56121 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYBZX4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:56:47 -0500
Date: Tue, 26 Feb 2008 17:56:31 -0600
From: David Fries <david@fries.net>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [W1] ds1wm: report bus reset error
Message-ID: <20080226235631.GA7616@spacedout.fries.net>
References: <20080225212445.GB29891@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225212445.GB29891@zarina>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Tue, 26 Feb 2008 17:56:34 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 12:24:45AM +0300, Anton Vorontsov wrote:
> The patch replaces dev_dbg() by dev_err(), so the user could actually
> see the error, instead of wondering why w1 doesn't work. The root cause
> of the bus reset error isn't yet debugged though, but this sometimes
> happens on iPaq H5555.

I'v been working on some of my own changes to the one wire system.
I'll need some testers eventually, what slave devices does the iPaq
have?  What's the scheduler timer Hz on the iPaq?

I have the USB ds2490 device and ds18b20 temperature sensor.  I've
worked though deadlocks in the base driver, and I'm right now
scratching my head on a USB bulk read and write timeout.  I'm running
it under qemu and I expect that is introducing some issues.  I intend
to patch it up when I get through that.  Hardly any of the changes
touch ds1wm, so we shouldn't be stomping on each other's feet.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
