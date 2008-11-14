Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYKNIoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYKNIoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYKNIof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:44:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:26234 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYKNIof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:44:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Sb9Pbn3YmHIrH/nTGe/JV/+edkQ3ormQqLbE3EMW3zWNbsFOo6bsHxyonO4CDGSO/a
         9igHcmsVRNFRFtBzckQkMLlxVyomDGttfMqTtY9aFSp4jkFP1Tl6hFEBHHdOIgeU6kLk
         7PDz5GY+2gQv855Do2zs4fHNofWy9vqcdbP3M=
Message-ID: <4104961b0811140044i7e57fedcw568ea1cd82f09167@mail.gmail.com>
Date: Fri, 14 Nov 2008 16:44:33 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Where is acpi_copy_wakeup_routine in lastest kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In kernels before 2.6.25 there is a function called
acpi_copy_wakeup_routine, but this routine is disappear ever since
2.6.26.

lfs:/usr/src/linux-2.6.25 # grep -r acpi_copy_wakeup_routine *
arch/x86/kernel/acpi/sleep.c:extern unsigned long
acpi_copy_wakeup_routine(unsigned long);
arch/x86/kernel/acpi/sleep.c:   acpi_copy_wakeup_routine(acpi_wakeup_address);
arch/x86/kernel/acpi/wakeup_32.S:# acpi_copy_wakeup_routine
arch/x86/kernel/acpi/wakeup_32.S:ENTRY(acpi_copy_wakeup_routine)
arch/x86/kernel/acpi/wakeup_64.S:# acpi_copy_wakeup_routine
arch/x86/kernel/acpi/wakeup_64.S:ENTRY(acpi_copy_wakeup_routine)

lfs:/usr/src/linux-2.6.26 # grep -r copy_wakeup_routine *
arch/x86/kernel/acpi/sleep.h:extern unsigned long
acpi_copy_wakeup_routine(unsigned long);

It's so strange that the definition is no longer there while there is
still a declaration. What's the story behind this?Thanks.

Regards
Jason
