Return-Path: <linux-kernel-owner+w=401wt.eu-S1945972AbXBVLdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945972AbXBVLdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945974AbXBVLdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:33:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:46703 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945972AbXBVLdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:33:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UzQ2cwG2vRVfO3YbWknM2DqGtiKhlEkxlJbnWw8SWhaOsQc+gpMRswJjD1fkg1mknhm7LeEbCJgIY3lFwm2Lb6rJPjWCt4A0+2S59u8ruIDZzKWg0P7qg/xw4H5HgFTQJca5dTCsOkDrWolr/9G9hsvduH8QhxSYzA6xrlCJHu4=
Message-ID: <e5ab0f710702220333k384d43b4r1bd07c64d55cbdc7@mail.gmail.com>
Date: Thu, 22 Feb 2007 12:33:37 +0100
From: "Francesco Pretto" <ceztko@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-Reply-To: <45DD37E9.7010303@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Fk9DulKIUBewV0V2B72MDzbelmU@ifi.uio.no>
	 <fa.RCbhxyLCSR5f65HWabMGmxZNYQ4@ifi.uio.no>
	 <fa.G4k+9fbJDE0N5pygu22mRYU6gfE@ifi.uio.no> <45DD37E9.7010303@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/22, Robert Hancock <hancockr@shaw.ca>:
>
> And yes, this is something we need to deal with. I don't think that
> disks that use contact start-stop heads care so much, but disks that use
> load-unload heads (like most laptop drives, it seems) generally quote a
> much lower cycle lifetime for "emergency unloads" caused by power loss
> than by normal unloads done while power is still applied. It's important
> enough that in some cases, like the Compaq X1000-series laptop I have,
> the BIOS appears to have a power button handler that spins down the
> drive before power-down when the power button is pressed and an ACPI OS
> isn't running. (Holding the button down when an ACPI OS is running just
> forces the power off, then you get the clunk from the drive..)
>
> Windows XP (and even as far back as Windows 98) get this right, surely
> we can do as well :-)
>
>

Yes, windows XP could handle better the power button pressed event
(causing the hd not to go to emergency parking, even when forced
shut-down, most of the times). But regarding a normal shut-down cycle,
isn't this a regression? You don't solve a regression adding a feature
(IMHO).
