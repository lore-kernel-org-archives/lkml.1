Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZATHb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZATHb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbZATHa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:30:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:58466 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZATHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S8uNrAm048t2u1eZvhvO+w7qOUYd5Yysy+pJosYsd9/Cd51L+OGKGAkxTjbvTDnLrC
         g/QBR89yFTsKchnE+EHCFBFe0MYJdGRHzo8qlhFclvmg4IEtJLejgbfp3AWWtlu6TEf5
         LrYUhmwpt3QQiI7mrqAjV/Klw1xHdVXWhyu5E=
Message-ID: <8db1092f0901192330u6b8a42adu2a4aa42ae88d72e3@mail.gmail.com>
Date: Tue, 20 Jan 2009 08:30:52 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/6] DMI: Introduce dmi_first_match to make the interface more flexible
Cc: "Jeff Garzik" <jeff@garzik.org>, "Frans Pop" <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200901192055.51108.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org>
	 <200901192053.50831.rjw@sisk.pl> <200901192055.51108.rjw@sisk.pl>
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
> using DMI information.  However, only the on-board controlles should
> be blacklisted and their PCI slot numbers can be used for this
> purpose.  Unfortunately the existing interface for checking DMI
> information of the system is not very convenient for this purpose,
> because to use it, we would have to define special callback functions
> or create a separate struct dmi_system_id table for each blacklisted
> system.
>
> To overcome this difficulty introduce a new function
> dmi_first_match() returning a pointer to the first entry in an array
> of struct dmi_system_id elements that matches the system DMI
> information.  Then, we can use this pointer to access the entry's
> .driver_data field containing the additional information, such as
> the PCI slot number, allowing us to do the desired blacklisting.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

Tested on HP Compaq nx6310

Thanks for patches


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
