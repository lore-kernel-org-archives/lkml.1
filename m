Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZATHbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZATHbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZATHbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:31:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:60859 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbZATHbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:31:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WU+oqqaZpKvB83melo7SALyym/6N96wAjzFIyMZ+gniER3SRBWZYf0VPw2DZ4SbgHI
         r+GX+Yf18bNXmRsUqg1utPkReAOFwsr0eKLFb5kPD0X3xTFu6zzp0z118sVtniBkgao9
         RXW3kadxGQHSDEdA13rP85JIuRZgw4Fs72TFA=
Message-ID: <8db1092f0901192331v54d6fbb6n1cbe18ed36579c28@mail.gmail.com>
Date: Tue, 20 Jan 2009 08:31:32 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/6] SATA: Blacklisting of systems that spin off disks during ACPI power off
Cc: "Jeff Garzik" <jeff@garzik.org>, "Frans Pop" <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200901192056.44529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org>
	 <200901192053.50831.rjw@sisk.pl> <200901192056.44529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introduce new libata flags ATA_FLAG_NO_POWEROFF_SPINDOWN and
> ATA_FLAG_NO_HIBERNATE_SPINDOWN that, if set, will prevent disks from
> being spun off during system power off and hibernation, respectively
> (to handle the hibernation case we need the new system state
> SYSTEM_HIBERNATE_ENTER that can be checked against by libata, in
> analogy with SYSTEM_POWER_OFF).
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

Tested on HP Compaq nx6310

Thanks for patches

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
