Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbXKNWaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbXKNWaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXKNW3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:29:55 -0500
Received: from rtr.ca ([76.10.145.34]:4168 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbXKNW3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:29:54 -0500
Message-ID: <473B76E0.7010500@rtr.ca>
Date: Wed, 14 Nov 2007 17:29:52 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1 - sata_mv (7042) hang with large file operations
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B44CB.6010209@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com>
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Morrison, Tom wrote:
> I have gotten it to boot from those hard-drives and it 
> has the same behavior:
> 
>   	Copying a large file to the same partition (>150MEG) 
>   	causes the system to hang (no I/O - no input/output - 
>   	nothing - complete freeze - like a primary resource 
>   	is locked up or interrupts got completely & totally 
>   	turned off in an ISR and its pending for something?
> 
> Only way to get out of this is to power-cycle the box!
..

Okay, a couple of things:

Do this from a text console, not a GUI.
And preferably without ever starting klogd/syslogd during init.

That way you've a much better chance of seeing some kernel diagnostic
messages when it locks up.

Can you boot with "nomsi" kernel parameter?
And I guess we'll need to see the entire kernel .config as well.

This is a tricky one.  The driver behaves fine for me
here with a 7042 rev.2 on PCIe in my x86-32 box.

Cheers
