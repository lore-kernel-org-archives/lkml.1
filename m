Return-Path: <linux-kernel-owner+w=401wt.eu-S1031084AbXDUODx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031084AbXDUODx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031123AbXDUODx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:03:53 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64905 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031084AbXDUODw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Q9jL9bFq4KX9cP8HnHT3umCnm9J7oStzUTv+A+rw9MLkKmbtFm/PzU5XrLx6YEFofaGKBL0g5GmG++JihCpH1PFxiSNMXpNtsM26CnMyhDE2KruRQJHWhK0NgQAX4KwaViEvMER+1IuKKgBXsCYwryVGrTLQMxq4j5+0vV6JLZo=
Message-ID: <8355959a0704210703n35b0dc35wcad04e5723eaec7@mail.gmail.com>
Date: Sat, 21 Apr 2007 19:33:52 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21-rc7 - ACPI issues?
Cc: "Andrew Morton" <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I did compile 2.6.21-rc7 for a P-III machine. Here is the ACPI part in
the dmesg:-

ACPI Error (psargs-0355): [PRSE] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKE._PRS] (Node dfd63f40), AE_NOT_FOUND
ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]
ACPI Error (psargs-0355): [PRSF] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKF._PRS] (Node dfd63ea0), AE_NOT_FOUND
ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]
ACPI Error (psargs-0355): [PRSG] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKG._PRS] (Node dfd63e00), AE_NOT_FOUND
ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]
ACPI Error (psargs-0355): [PRSH] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.LNKH._PRS] (Node c147d75c), AE_NOT_FOUND
ACPI Exception (pci_link-0180): AE_NOT_FOUND, Evaluating _PRS [20060707]

I tried with few configurations (config) to solve the problem, am not
sure what's causing this failure. Any hint?


~Akula2
