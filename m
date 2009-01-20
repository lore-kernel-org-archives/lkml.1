Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbZATHct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbZATHct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZATHch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:32:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:62495 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZATHcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:32:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RXhS45T1tETplkqqHUMQKgNUi42US5+WOrOmupUJvRm9Moe8yubclusLrxH3D/V5B9
         0Ie477Xz+/z7By+EfFkDrW5Png6WJcuXNlYjWzCEMDLe1NL/nTNgr/gt4J1GkLpi1QwH
         LbpDcv5kl0Zt+EB0zUfqLKoOVSrG6CPmnYhLs=
Message-ID: <8db1092f0901192332y7defe6ddy680353eae8eab8d9@mail.gmail.com>
Date: Tue, 20 Jan 2009 08:32:33 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 5/6] SATA Sil: Blacklist system that spins off disks during ACPI power off
Cc: "Jeff Garzik" <jeff@garzik.org>, "Frans Pop" <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200901192058.30489.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org>
	 <200901192053.50831.rjw@sisk.pl> <200901192058.30489.rjw@sisk.pl>
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
> Blacklist HP nx6325 that uses the sata_sil driver.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

Tested on HP Compaq nx6310

Thanks for patches
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
