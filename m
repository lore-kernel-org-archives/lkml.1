Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZBSPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZBSPIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZBSPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:08:13 -0500
Received: from ns1.suse.de ([195.135.220.2]:54259 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZBSPIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:08:12 -0500
Date: Thu, 19 Feb 2009 16:08:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Tobias Kaminsky <mail@finswimmer.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No Scancodes for "Logitech NuLOOQ"
In-Reply-To: <200902191216.24045.mail@finswimmer.de>
Message-ID: <alpine.LRH.1.10.0902191606360.11868@twin.jikos.cz>
References: <200902191216.24045.mail@finswimmer.de>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009, Tobias Kaminsky wrote:

> 589827 (0x90003)
> 589827 (0x90003)
> 589825 (0x90001)
> 589825 (0x90001)
> 589825 (0x90001)
> 589828 (0x90004)
> 589825 (0x90001)
> 589828 (0x90004)
> 589826 (0x90002)
> 589826 (0x90002)
> 589829 (0x90005)
> 589829 (0x90005) Button "II"

Do these events come out of kernel correctly? I.e. what is the output of

	evtest /dev/input/event3

when pressing these buttons?

> But the NuLOOQ has a "navring" which you can turn left/right. This does 
> not generates a scancode.

Could you please compile the kernel with CONFIG_HID_DEBUG enabled, 
modprobe the 'hid' module with 'debug=2' parameter, move the "narving" in 
both directions, and send me the output that appears in dmesg?

Thanks,

-- 
Jiri Kosina
SUSE Labs

