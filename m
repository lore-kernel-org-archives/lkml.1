Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGSPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGSPZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 11:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYGSPZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 11:25:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1796 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754825AbYGSPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 11:25:31 -0400
Date: Sat, 19 Jul 2008 11:25:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re  [patch 2/3] fastboot: turn the USB hostcontroller initcalls into
 async initcalls
Message-ID: <Pine.LNX.4.44L0.0807191116370.3491-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July, 2008, Arjan van de Ven wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] fastboot: turn the USB hostcontroller initcalls into 
> async initcalls
> 
> the USB host controller init calls take a long time, mostly due to a
> "minimally 100 msec" delay *per port* during initialization.
> These are prime candidates for going in parallel to everything else.
> 
> The USB device ordering is not affected by this due to the
> serialized-within-eachother property of async initcalls.

Is there some reason this patch wasn't posted to the linux-usb mailing
list as well as to LKML?

Where is this "minimally 100 msec" per-port delay you refer to?  
Offhand I can't recall any such delays in the init routines.

Alan Stern

