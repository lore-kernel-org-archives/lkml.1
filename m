Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYDIRga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYDIRga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYDIRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:36:22 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:60171 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYDIRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LiGbuZHLrL4ntx3RqO59HuE4ud9fZ29TiPyVPb/VdQyEwb1zfV7ZZMO27Lp6WgKG+dC/zY+i24Mvy28YRpnUNLMsx4FeQp34LFRxELKE8X4yjSRubpddXsqacv1vojg4Ni0m5COxwI7E0/X7IljoCwK6/EWUVxcUupo0l7hZYRM=
Message-ID: <86802c440804091036p3a3837e8td8f17d6195561aaf@mail.gmail.com>
Date: Wed, 9 Apr 2008 10:36:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Pavel Machek" <pavel@suse.cz>
Subject: build error on x86_64 with x86.git#latest
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0465ac59164eda30f4fe49006a67dd6d2c9fc3cf
Author: Pavel Machek <pavel@suse.cz>
Date:   Wed Feb 20 01:48:39 2008 +0100

    suspend: wakeup code in c

        Suspend: Wakeup code in C

cause

In file included from arch/x86/kernel/acpi/sleep.c:14:
arch/x86/kernel/acpi/sleep.h:12: error: conflicting types for 'initial_code'
include/asm/smp.h:62: error: previous declaration of 'initial_code' was here
make[2]: *** [arch/x86/kernel/acpi/sleep.o] Error 1
make[1]: *** [arch/x86/kernel/acpi] Error 2
make: *** [arch/x86/kernel] Error 2

YH
