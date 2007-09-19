Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbXISLqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbXISLqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbXISLqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:46:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbXISLqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:46:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Gerdau <mgerdau@tiscali.de>
Subject: Re: 2.6.23-rc6-mm1 and acpi
Date: Wed, 19 Sep 2007 13:59:14 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200709182342.39905.mgerdau@tiscali.de>
In-Reply-To: <200709182342.39905.mgerdau@tiscali.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709191359.15050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 18 September 2007 23:42, Michael Gerdau wrote:
> Hi,
> 
> while trying to compile 2.6.23-rc6-mm1 I came across the following
> build error:
> 
> mgd@seneca:/usr/src/linux-2.6.23-rc6-mm1> make modules
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
> <stdin>:1389:2: warning: #warning syscall revokeat not implemented
> <stdin>:1393:2: warning: #warning syscall frevoke not implemented
>   CC [M]  drivers/acpi/sbs.o
> drivers/acpi/sbs.c: In function ‘acpi_battery_alarm_show’:
> drivers/acpi/sbs.c:457: error: implicit declaration of function ‘acpi_battery_get_alarm’
> drivers/acpi/sbs.c: In function ‘acpi_battery_alarm_store’:
> drivers/acpi/sbs.c:472: error: implicit declaration of function ‘acpi_battery_set_alarm’
> drivers/acpi/sbs.c: In function ‘acpi_battery_add’:
> drivers/acpi/sbs.c:829: warning: ignoring return value of ‘device_create_file’, declared with attribute warn_unused_result
> make[2]: *** [drivers/acpi/sbs.o] Fehler 1
> make[1]: *** [drivers/acpi] Fehler 2
> make: *** [drivers] Fehler 2
> 
> Not sure who to CC, which is why I send it to the list alone.

Patch here: http://marc.info/?l=linux-acpi&m=119019799008585&w=4

