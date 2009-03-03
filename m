Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbZCCQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbZCCQXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZCCQXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:23:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbZCCQXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:23:05 -0500
Date: Tue, 3 Mar 2009 17:23:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tobias Kaminsky <mail@finswimmer.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No Scancodes for "Logitech NuLOOQ"
In-Reply-To: <200902191709.29334.mail@finswimmer.de>
Message-ID: <alpine.LNX.2.00.0903031721320.5295@jikos.suse.cz>
References: <200902191216.24045.mail@finswimmer.de> <alpine.LRH.1.10.0902191606360.11868@twin.jikos.cz> <200902191709.29334.mail@finswimmer.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009, Tobias Kaminsky wrote:

> modprobe hid debug=2 gives me this when I plug in the device:
> (very long)
> But it does not react on the navring nor on the buttons.

So there is absolutely zero output in dmesg with hid debug when you press 
these buttons, right?

Hmm, that's sounds fishy. Could you please capture usbmon traces of these 
events? (Documentation/usb/usbmon.txt will tell you how to do it).

Thanks,

-- 
Jiri Kosina
SUSE Labs
