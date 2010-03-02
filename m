Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0CBQ4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:56:34 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:34124 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0CBQ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MH9UfDL59QO6/dnVJUcWTUzpWhRWlPVYj33SzVN32rp3bVbRREMA8jNjSIi64YW1h1
         VniNtgYyY5tQo0sbogf+UMN8rZt3IIcryQeVlDb5fUqZy68OYfrzTeuS+B05LRMxUwH/
         JVVMYg2YTAp5G2O6RaAIKAgttjpfJi6g8nZBI=
MIME-Version: 1.0
Date: Tue, 2 Mar 2010 22:26:32 +0530
Message-ID: <b2ac5deb1003020856u37083469q160cebb780c24c58@mail.gmail.com>
Subject: Booting kernel on 2nd Core
From: Swapnil Pimpale <swapnil.pict@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am working on Intel Core 2 Duo processor. As part of my academic
project, I want to boot Linux Kernel from 2nd core. I have
successfully jumped to the start address (1MB) of the kernel from 2nd
core. But it gets stuck in the function calibrate_delay().
If I comment the call to calibrate_delay and proceed with the kernel
boot-up, it goes ahead and gets stuck at some other point (in
acpi_ut_osi_implementation()).
In the meanwhile I have put the 1st core in an infinite loop.
I have configured the kernel to be an uni-processor kernel. (i.e.
disabled SMP support)

Could someone please let me know the reason for this problem. Will I
have to make any changes to kernel code for it to boot on 2nd core?

Thanks,
Swapnil A. Pimpale.
