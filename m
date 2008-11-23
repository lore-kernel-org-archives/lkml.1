Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYKWUdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYKWUdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbYKWUdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:33:24 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45852 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139AbYKWUdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:33:22 -0500
Date: Sun, 23 Nov 2008 21:33:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Christoph Bartelmus <lirc@bartelmus.de>
cc: pavel@suse.cz, jonsmirl@gmail.com, jrm8005@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: In-kernel IR remote control support
In-Reply-To: <AqQThtpZjFB@christoph>
Message-ID: <alpine.LRH.1.10.0811232128050.26670@twin.jikos.cz>
References: <AqQThtpZjFB@christoph>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008, Christoph Bartelmus wrote:

> You can have LIRC setup to decode all common remote control protocols.  
> It's just a matter of proper packaging and pre-configuration. You don't 
> have to write a single line of code for this (I still have to add uinput 
> support, though, which I probably would have done by now, if I weren't 
> busy writing posts like this).

Just a question -- how much is the situation different to what we 
currently have for HID devices?

For these, we currently have common code, that is able to handle all the 
"normal" devices by default, that are fully compliant with the HID 
standard.
For the devices that don't behave that well, we have specialized drivers, 
that use all the generic HID infrastructure to handle the 
standard-compliant behavior of the device and allows the specialized 
drivers to implement only the parts that violate standard.

It's pretty lightweight and seems to work well. Wouldn't this work also 
for LIRC drivers?

-- 
Jiri Kosina
SUSE Labs

