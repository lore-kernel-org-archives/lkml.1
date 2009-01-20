Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbZATHcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbZATHcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZATHcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:32:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:60859 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZATHb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:31:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c+jGgXulP7b7dQ/5FA661zKvSUa/48NG0Q1sqr73Ql4/b5g08D0xyRs8RTUMteCRRU
         k5gpLtuPp1s1B369Gh//X2pjuLy24w7lU+5iXb0Vq0T5Sot5r3EW58dkFterhsPBl2Wx
         u2rrNKq8k5pmi0qUU8vSPtwiAG2PuHZRGwp3s=
Message-ID: <8db1092f0901192331s7d35a3b8j26f5499fba9c6fb2@mail.gmail.com>
Date: Tue, 20 Jan 2009 08:31:57 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/6] SATA AHCI: Blacklist system that spins off disks during ACPI power off
Cc: "Jeff Garzik" <jeff@garzik.org>, "Frans Pop" <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200901192057.37643.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org>
	 <200901192053.50831.rjw@sisk.pl> <200901192057.37643.rjw@sisk.pl>
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
> Blacklist HP nx6310 that uses the AHCI driver.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

Tested on HP Compaq nx6310

Thanks for patches


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
