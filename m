Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYBSRz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYBSRz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYBSRzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:55:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36863 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYBSRzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:55:16 -0500
Message-ID: <47BB1801.1000008@garzik.org>
Date: Tue, 19 Feb 2008 12:55:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: random wedges with 2.6.25-rc*
References: <20080219191035.252d5787@mjolnir.drzeus.cx>
In-Reply-To: <20080219191035.252d5787@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Somewhere post 2.6.24, the kernel started getting very temperamentful. I experience random hangs and wedges very often.
> 
> Primarily, the udev startup locks up. If I abort it, it just locks up on more or less every action after that. Some quick debugging showed that I had a whole bunch of modprobe processes sitting around. The new CONFIG_USB_ANNOUNCE_NEW_DEVICES setting makes every startup of udev lock up consistently on at least two machines. It does not seem to be the root of the problem as disabling the option just makes the bug very unlikely.
> 
> I've also seen a couple of lockups in X. Might be a different expression of the same bug, but the effect here is a complete wedge of the user interface. It seems the rest of the machine also locks up, but I haven't confirmed this.
> 
> Anyone else seeing these problems? Someone should as I've seen the problem on both a Lenovo and a HP laptop here.


I'm definitely seeing lockups here too.  2.6.24 is fine, 2.6.24-rc1 or 
-rc2 locks up a minute or so after a successful boot (either to console 
or to X).

Does the following shed any light?

http://lkml.org/lkml/2008/2/17/78

	Jeff



