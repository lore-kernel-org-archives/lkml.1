Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbZHOKaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbZHOKaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZHOKaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:30:08 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:43194 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZHOKaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=hFUa4+AFw+rZlJhiwxD3YBoZwzX+XDfMs+Zq6eu/z3gXzXDUmxAhFwtL2/R061rssl
         5PHeUfdd/orZLlulqPwa6Ve9dDtO96Xin9yyFN0HOcyBTY9+YviC/A07gOLCWm6F/Vu7
         IuckegWyxay2ZmxrvkoG9fOLgrP2fAyJVDgnE=
MIME-Version: 1.0
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sat, 15 Aug 2009 13:29:48 +0300
Message-ID: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
Subject: [BUG] [hwmon] linux 2.6.31-rc6 regression
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since upgrading from vanilla 2.6.31-rc5 to vanilla 2.6.31-rc6, my
onboard temp/fan/voltage sensors stopped working.
The motherboard is an asus p5k-e with a w83627ehf sensors chip.

In the new dmesg it says:

[    3.276720] w83627ehf: Found W83627DHG chip at 0x290
[    3.276894] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts
with ACPI region HWRE [0x290-0x299]
[    3.277171] ACPI: Device needs an ACPI driver

I can provide more data, perform tests, whatever you need.

I am not setup for git bisect (I compile tarballs), but if no one can
figure it out I'll do that too, it is easy to reproduce.

I am not subscribed to the list, please cc: me. In any case I'll
follow this thread on archives.

I'm using the nvidia binary blob, but this happens before it is loaded
and so I will not even bother to reproduce without it.

-Zeev
