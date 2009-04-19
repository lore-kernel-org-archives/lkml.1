Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZDSElx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZDSElx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZDSEll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:41:41 -0400
Received: from smtp.knology.net ([24.214.63.101]:48355 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZDSEll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:41:41 -0400
Subject: Re: [PATCH net-next] myri10ge: allow per-board firmware overriding
From: David Dillow <dave@thedillows.org>
To: David Miller <davem@davemloft.net>
Cc: brice@myri.com, sgruszka@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090418.210927.229687293.davem@davemloft.net>
References: <20090417095038.49b745bf@dhcp-lab-109.englab.brq.redhat.com>
	 <49EA1DAC.1000602@myri.com>
	 <1240102617.5342.6.camel@obelisk.thedillows.org>
	 <20090418.210927.229687293.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 00:41:39 -0400
Message-Id: <1240116099.5342.18.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-18 at 21:09 -0700, David Miller wrote:
> From: David Dillow <dave@thedillows.org>
> Date: Sat, 18 Apr 2009 20:56:57 -0400
> 
> > It seems like this could be done in user space, using the PCI bus ID as
> > a key to select the firmware.
> 
> PCI BUS ID's are not in any way unique, you would need to include the
> PCI Domain as well.

I had that in mind, but I wasn't precise in my wording. I think that
info is there as well. IIRC, and brief glance at the code suggests, that
the uevent for the firmware requests gets the environment variable
DEVPATH that would contains that info:

DEVPATH=/devices/pci0000:00/0000:00:1e.0/0000:09:01.0

Now I'm curious, so I'll probably re-verify that with udevmonitor, a
recent kernel and the typhoon driver, since it is the only thing I have
that requests firmware. But sometime after I sleep...

