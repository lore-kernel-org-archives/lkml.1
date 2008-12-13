Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYLMNa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYLMNa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 08:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYLMNaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 08:30:13 -0500
Received: from styx.suse.cz ([82.119.242.94]:45092 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755216AbYLMNaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 08:30:11 -0500
Date: Sat, 13 Dec 2008 14:30:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Matt Helsley <matt.helsley@gmail.com>
cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix genius pensketch 12x9 tablet
In-Reply-To: <1229150548.11171.6.camel@molly>
Message-ID: <alpine.LNX.1.10.0812131429350.21089@jikos.suse.cz>
References: <1229150548.11171.6.camel@molly>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Matt Helsley wrote:

> The Genius PenSketch 12x9 tablet has a puck (labeled a "Tablet Mouse") 
> in addition to a pen. Without registering a quirk the tablet appears to 
> be a single input device that reports the wrong axis information in 
> /proc/bus/input/devices, and sends incorrect events (e.g. ABS_Z instead 
> of ABS_Y). This information confuses the X evdev driver and makes the 
> device impossible to use.
> The quirk fixes events and splits the device into multiple input
> event devices so that at least the puck is useful.

I have applied the patch to HID tree, thanks a lot Matt.

-- 
Jiri Kosina
SUSE Labs
