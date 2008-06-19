Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbYFSSoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbYFSSoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYFSSoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:44:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51544 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYFSSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:44:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <485AA8E5.7030805@s5r6.in-berlin.de>
Date: Thu, 19 Jun 2008 20:43:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, mdharm-usb@one-eyed-alien.net,
       linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de>
In-Reply-To: <485AA7EA.6080105@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> The problem is AFAIU not exactly how many Scsi_Host instances (initiator 
> port representations, or something remotely related to that) are 
> instantiated, but rather _when_ they are instantiated.  On multi 
> protocol buses or networks like USB and FireWire, it makes sense to 
> create the SCSI initiator port representation when we discovered that 
> there are actually SCSI targets on the bus or network.
> 
> scsi_scan's API

scsi_wait_scan's API

> is geared towards drivers which create one or more 
> initiator port representations right up front before going on target 
> discovery, right?
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
