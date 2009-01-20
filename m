Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZATHdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZATHdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZATHdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:33:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:50249 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZATHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N97TdS7ZSxiXxmSAYl8ElcAD32mrDB/HMOVSQ6JvM3mmSTf/UveGK/vpTg3vgj9y3C
         R8an+vkvUvgUVYbG933HEV5/FnSGfeXo1ynPFjlHYFhvAxQSWC5IXk4aBilzGnxmt9d7
         U9WF3P9Txb+75WZJlwk/Ps+WgIoOjjSkaYzuA=
Message-ID: <8db1092f0901192333p31d7b924o6a00084851376578@mail.gmail.com>
Date: Tue, 20 Jan 2009 08:33:07 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 6/6] SATA PIIX: Blacklist system that spins off disks during ACPI power off
Cc: "Jeff Garzik" <jeff@garzik.org>, "Frans Pop" <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200901192059.23448.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org>
	 <200901192053.50831.rjw@sisk.pl> <200901192059.23448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Some notebooks from HP have the problem that their BIOSes attempt to
> spin down hard drives before entering ACPI system states S4 and S5.
> This leads to a yo-yo effect during system power-off shutdown and the
> last phase of hibernation when the disk is first spun down by the
> kernel and then almost immediately turned on and off by the BIOS.
> This, in turn, may result in shortening the disk's life times.
>
> To prevent this from happening we can blacklist the affected systems
> using DMI information.
>
> Blacklist HP 2510p that uses the ata_piix driver.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

Tested on HP Compaq nx6310

Thanks for patches

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
