Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZATHaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZATHaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZATHaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:30:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:49944 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZATHaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:30:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NQg2+nO4JdMQYetd+2O9xYKcC1x7vZcEP8jSmxCV47RhSdpv9Siz9HFON8+yPCGKvi
         djTZhxMGfuIid5NkoD3VWBfQ8fnbeoN3Z9uL7IgjZBzi3nCqF+997PQYxL5i+hgfsfZs
         3PU2oIIrOymlqXJP/lQl/GAYafqs2dAm7vDMc=
Message-ID: <8db1092f0901192330n43ba88bbk20f79233aad48c0a@mail.gmail.com>
Date: Tue, 20 Jan 2009 08:30:05 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Cc: "Jeff Garzik" <jeff@garzik.org>, "Frans Pop" <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200901192054.55536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org>
	 <200901192053.50831.rjw@sisk.pl> <200901192054.55536.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introduce boolean function system_entering_hibernation() returning
> 'true' during the last phase of hibernation, in which devices are
> being put into low power states and the sleep state (for example,
> ACPI S4) is finally entered.
>
> Some device drivers need such a function to check if the system is
> in the final phase of hibernation.  In particular, some SATA drivers
> are going to use it for blacklisting systems in which the disks
> should not be spun down during the last phase of hibernation (the
> BIOS will do that anyway).
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

Tested on HP Compaq nx6310

Thanks for patches

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
