Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXKMSAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXKMSAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbXKMSAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:00:14 -0500
Received: from main.gmane.org ([80.91.229.2]:49762 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759447AbXKMSAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:00:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Boelstler <kernel@boelstler.net>
Subject: Re: Strange delays / what usually happens every 10 min?
Date: Tue, 13 Nov 2007 18:58:35 +0100
Message-ID: <fhcok9$jv0$3@ger.gmane.org>
References: <fhcc39$51b$1@ger.gmane.org> <4739CBF0.8000500@redhat.com> <4739D5E1.5060108@anagramm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: fw-emea.rohde-schwarz.com
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
In-Reply-To: <4739D5E1.5060108@anagramm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

Clemens Koller wrote:
>  > This is precisely the sort of thing that BIOS/firmware-level SMI
>  > handlers do, particularly those that have monitoring or management
>  > features.  Try to determine if the kernel is doing anything during this
>  > time.  If the entire kernel seems to be frozen, talk to the people who
>  > wrote the firmware.
> 
> There is no such thing as BIOS on this MPC8540 embedded system.
> I guess he is also using some bootloader which just gives full
> control to the linux kernel.

Correct, it's the U-Boot boot loader.

> Florian:
> Check the IP route chache flushes, as Eric mentioned.
> I'm working on the MPC854x as well. If you send me your scripts,
> I can give them a run here to gather more information.
> (I'm about to update my kernels here)

Thanks, the rhash_entries argument seems to have cured the problem.

Cheers,

   Florian

