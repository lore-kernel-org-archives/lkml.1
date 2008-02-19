Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYBST6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYBST6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYBST6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:58:09 -0500
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:34853 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYBST6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:58:07 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: random wedges with 2.6.25-rc*
Date: Tue, 19 Feb 2008 19:58:04 +0000
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20080219191035.252d5787@mjolnir.drzeus.cx>
In-Reply-To: <20080219191035.252d5787@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191958.04786.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 18:10:35 Pierre Ossman wrote:
> Primarily, the udev startup locks up. If I abort it, it just locks up on
> more or less every action after that. Some quick debugging showed that I
> had a whole bunch of modprobe processes sitting around. The new
> CONFIG_USB_ANNOUNCE_NEW_DEVICES setting makes every startup of udev lock up
> consistently on at least two machines. It does not seem to be the root of
> the problem as disabling the option just makes the bug very unlikely.

You're not alone, I'm seeing these intermittent hangs at init time on Debian 
unstable at:

"Waiting for /dev to be fully populated" (udevsettle)

"Loading kernel modules" (which I assume is modprobe)

But, I'm not seeing any hangs in X11 (yet).

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
