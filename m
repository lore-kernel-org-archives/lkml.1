Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXKYSkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXKYSkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 13:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXKYSkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 13:40:01 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59163 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbXKYSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 13:39:59 -0500
Date: Sun, 25 Nov 2007 12:39:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.24: Serial disabled in BIOS but serial modules still loaded
 (probably PnP related)
In-reply-to: <fa.P01QcmUf2f3DN4etI8KJYFdaLnE@ifi.uio.no>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-id: <4749C15C.6020805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.P01QcmUf2f3DN4etI8KJYFdaLnE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> I have no COM port on notebook (without port replicator which I do not have)
> so COM is disabled in BIOS. No ttyS* is detected during boot (and no device
> created) but I just noticed that serial modules are still loaded. Well, this
> partially defeats the purpose of disabling COM port - the intention was to
> free resources by *not* loading unneeded modules ...
> 
> This may have something to do with (ACPI) PnP which apparently believes COM is alive.
> Notebook is Toshiba Portege 4000.

Probably a BIOS bug. It still lists the port in PnP data even though the 
hardware is disabled, so the kernel still tries to load the serial 
driver for it, which finds there's no port there.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

