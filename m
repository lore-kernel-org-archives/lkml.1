Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYEAPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYEAPzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762189AbYEAPy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:54:56 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:49483 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761688AbYEAPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BKlJwwzxgasUiRtl5j7T/gWnN8ePeRnEasNtDYq/Gq4BhK3Jl2zHLGaATDXBa3wrTdNO65nKr8A+GJ/GkumMYcfKm63eVN+5/bM9nKwbcQbRCglkydC2v7bHvhG1JFNd1LVb92dacUEtOuaoAFE6mKEM1jhw9BjAEz+nGyZaOqU=
Message-ID: <804dabb00805010854t7c593c1dl271f3634863d2137@mail.gmail.com>
Date: Thu, 1 May 2008 23:54:54 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: make[1]: *** [drivers/built-in.o] Error 1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing a make on the latest linus tree gives:

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  LDS     arch/x86/kernel/acpi/realmode/wakeup.lds
  LD      arch/x86/kernel/acpi/realmode/wakeup.elf
ld: warning: dot moved backwards before `.text'
ld: warning: dot moved backwards before `.text'
ld: warning: dot moved backwards before `.text'
  OBJCOPY arch/x86/kernel/acpi/realmode/wakeup.bin
  AS      arch/x86/kernel/acpi/wakeup_rm.o
  LD      arch/x86/kernel/acpi/built-in.o
  LD      arch/x86/kernel/built-in.o
  LD      drivers/built-in.o
ld: drivers/media/built-in.o: No such file: No such file or directory
make[1]: *** [drivers/built-in.o] Error 1
make: *** [drivers] Error 2

a.   What is the cause of the error?
b.   Is there a relationship between the ld-warning and the subsequent
errors as shown above?

Thanks.

-- 
Regards,
Peter Teoh
