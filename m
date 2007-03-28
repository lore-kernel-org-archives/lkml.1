Return-Path: <linux-kernel-owner+w=401wt.eu-S965775AbXC1UY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965775AbXC1UY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965776AbXC1UY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:24:28 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:38248 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965775AbXC1UY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:24:27 -0400
Message-ID: <460ACEF3.8090502@gmail.com>
Date: Wed, 28 Mar 2007 22:24:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Keenan Pepper <keenanpepper@gmail.com>, linux-kernel@vger.kernel.org
Subject: ACPI Exception: Index is beyond end of object [Was: Timeouts on ICH7
 PATA drive with ata_piix; ide_generic works perfectly]
References: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com> <3877989d0702041956h1a423cafy40aef4aa4d8a1dc9@mail.gmail.com>
In-Reply-To: <3877989d0702041956h1a423cafy40aef4aa4d8a1dc9@mail.gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 28 Mar 2007 22:24:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luming Yu napsal(a):
>> From the dmesg, I found a problem NOT relative to the PATA driver.
> I would like to know if cpu freq driver works? If not, please enter a
> acpi bug on bugzilla.kernel.org.

I can't see a bugzilla entry for this?

> "[   17.368000] ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT,
> Index (0FFFFFFFD) is beyond end of object [20060707]
> [   17.368000] ACPI Error (psparse-0537): Method parse/execution
> failed [\_PR_.CPU1._PSS] (Node c1468ba8), AE_AML_PACKAGE_LIMIT
> [   17.368000] ACPI Exception (acpi_processor-0235):
> AE_AML_PACKAGE_LIMIT, Evaluating _PSS [20060707]
> [   17.368000] ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT,
> Index (0FFFFFFFD) is beyond end of object [20060707]
> [   17.368000] ACPI Error (psparse-0537): Method parse/execution
> failed [\_PR_.CPU2._PSS] (Node c14689f0), AE_AML_PACKAGE_LIMIT
> [   17.368000] ACPI Exception (acpi_processor-0235):
> AE_AML_PACKAGE_LIMIT, Evaluating _PSS [20060707]

Was this solved somehow? I get this while modprobing acpi_cpufreq first
time, any further probe is OK:

ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFD) is
beyond end of object [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU1._PSS]
(Node ffff81003ff05f30), AE_AML_PACKAGE_LIMIT
ACPI Exception (processor_perflib-0234): AE_AML_PACKAGE_LIMIT, Evaluating
_PSS [20070126]
ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFD) is
beyond end of object [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU2._PSS]
(Node ffff81003ff05c70), AE_AML_PACKAGE_LIMIT
ACPI Exception (processor_perflib-0234): AE_AML_PACKAGE_LIMIT, Evaluating
_PSS [20070126]

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
