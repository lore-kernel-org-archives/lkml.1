Return-Path: <linux-kernel-owner+w=401wt.eu-S2993144AbXEBT34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993144AbXEBT34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993153AbXEBT3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:29:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:26336 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993144AbXEBT3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Itmoe67pRyOFx4fpInHy+PwWuTVMR1WbsM9sUKaAoBOzX0jvBAE0xdH+wtpmTH3cntt+238zf4ZEzazsnGC/fqazrEKNd/lf1N5snwzOL33dJSrl78AqHA55omYCTY+XGUEJ3BNHIrahyDpYMz19H+/SNI0nlZgP9N74VnMn5A8=
Message-ID: <df47b87a0705021229o6fb42d06ka8e37d1fdc32520a@mail.gmail.com>
Date: Wed, 2 May 2007 15:29:52 -0400
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: More JMicron troubles with 2.6.21
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       htejun@gmail.com
In-Reply-To: <20070502201511.4c8085e9@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df47b87a0705021037k7dc2d408mcdddbc83daa3b68b@mail.gmail.com>
	 <20070502201511.4c8085e9@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> This is almost certainly a problem outside of the IDE handling in that
> case. The jmicron controllers are smart, there is basically no code to
> the IDE driver to go wrong (especially in the case of using the old IDE
> for the PATA port where you basically use zero code that hasn't been
> tested for years).
Could this be a hardware problem then? The CD-ROM is recognized by
BIOS and I'm able to boot bootable CDs fine.
Could it be a setting in BIOS? I did try to switch from Enhanced to
Compatible mode, but problem persists.
With the ide driver, the device is recognized, but when I attempt to
mount it, il times out, gets reset and my machine locks up at times.
>
> Do you get the odd timeout or continuous timeouts ?
With the pata_jmicron, the device is not recognized. I get the
timeouts only during the probing during the boot phase.
