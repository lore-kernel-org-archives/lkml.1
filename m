Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYCRHgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYCRHgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYCRHg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:36:29 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:51403 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYCRHg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=N1hgNP+uLvueyptBb373zRKIH2rm97h0wCwO/W+yqC68pjJGoHg6v0K5vIlWskjxJvnTEHH1ZyVlutyFS0cJZaLxS9Z/L1RJsKKz+SArScC1IvjVCXw38Grt7umvK2Fmpnnqapqv1uwOhhQSXVVITiGRrTcYvmCoSiMqGvMDbMc=
Message-ID: <47DF70F3.9080305@gmail.com>
Date: Tue, 18 Mar 2008 16:36:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <47D5320E.8020107@gmail.com> <200803170816.50597.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200803170816.50597.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Volker Armin Hemmann wrote:
> I tried some more stuff, replaced the cables, played with bios settings.
> 
> No change.
> 
> Then I updated to 2.6.24.3 - and no hangs or 'softreset' failures anymore.

I don't see any libata changes which can cause such difference.  Weird.
 Is this result reliably reproducible?

> The only change to other kernels was making ehci-hcd modular. 

Hmmm...

> I checked already, other kernels still have the IDENTITY error on coldboot and 
> the softreset failure on reboot even with the changed config.

Hmmm...

> 2.6.24.2 and 2.6.24.3 both have the reiser4 patch added.
> 
> So
> 2.6.24.2 = bad
> 2.6.24.3 = good
> 2.6.25-rc5 = bad 
> 
> Setting AHCI in bios still results in timeouts and harddisks not found.

Does pci=nomsi help?

-- 
tejun
