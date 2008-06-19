Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYFSVTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYFSVTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYFSVTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:19:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53203 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYFSVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:19:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <485ACD5D.6070303@s5r6.in-berlin.de>
Date: Thu, 19 Jun 2008 23:19:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org> <20080619195240.GX19934@one-eyed-alien.net> <20080619204954.GQ4392@parisc-linux.org>
In-Reply-To: <20080619204954.GQ4392@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's face it, from the POV of several if not all transport layer 
drivers, the core API element Scsi_Host is just a superfluous appendage 
to the only interesting elements -- target and logical unit, or even 
logical unit alone.

Matthew Wilcox wrote:
> I would suggest that you want one 'channel' per usb endpoint.

No, "channel" is meaningless.  Friends don't let friends invent new 
meanings for "channel".
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
