Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbXDAO5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbXDAO5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXDAO5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:57:41 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:30949 "EHLO
	asav00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbXDAO5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:57:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwPAFZlD0ZKhRO4UGdsb2JhbACHO4hCAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
Date: Sun, 1 Apr 2007 10:57:40 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, Dan Engel <dan@sourceharvest.com>
References: <1175396188.7857.15.camel@monica.engel.home> <Pine.LNX.4.64.0704011057420.6040@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704011057420.6040@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704011057.40725.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2007 05:01, Jiri Kosina wrote:
> On Sat, 31 Mar 2007, Dan Engel wrote:
> 
> > This patch is really being offered because it's what's needed to make the operation
> > of the Belkin Flip USB KVM switch avaiable to user-space programs through the HID input
> > event interface. The Belkin Flip KVM overloads LED usages to give software control
> > over the device, providing options to flip either audio, video or both. However,
> > without an input mapping to the Off-hook and Speaker LED usages, this functionality
> > isn't available.
> 
> Dmitry, would adding these two LED_ constants to input.h be OK by you? 
> (the coresponding usages are defined in HUT 1.12 on page 62).
> 

No, I do not want to add any more LED constants to input. In fact I think
that adding constants beyond keyboard indicators was a mistake. We have 
led subsystem that provides interface to control arbitrary leds and we
should use it.

-- 
Dmitry
