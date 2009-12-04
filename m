Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbZLDNcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbZLDNcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZLDNcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:32:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55450 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbZLDNcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=G+g4LqLFnnRcKkA+n6D5K6/ddNivTJbe8M2wKbWY2MuEzicYU0nWJaL8SZecrrDKXQ
         iUinrx+X96KkQBGPE2a2xV9rdXS+UWFNIwgpME/Ercian4yORFDKiy2Tj314jRbqKLTp
         OgHeJGqFxO1iwmRVKV/UC3p6RAEd38GmESFO0=
MIME-Version: 1.0
Date: Fri, 4 Dec 2009 14:32:08 +0100
Message-ID: <c5bd819b0912040532x13b7e564ve7f37badb0aaa521@mail.gmail.com>
Subject: Can't compile 2.6.32
From: Grozdan <neutrino8@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm having trouble trying to compile the 2.6.32 kernel on my openSUSE
11.1 system. While doing so, I see a lot of warnings which seem to
come from include/acpi/acpiosxf.h and then when the compile process
enters the drivers/acpi directory, it errors out with the following:

  CC      drivers/acpi/tables.o
In file included from include/acpi/acpi.h:63,
                 from include/linux/acpi.h:39,
                 from drivers/acpi/tables.c:33:
include/acpi/acpiosxf.h: In function ‘acpi_load_override_tables’:
include/acpi/acpiosxf.h:98: warning: no return statement in function
returning non-void
  CC      drivers/acpi/blacklist.o
In file included from include/acpi/acpi.h:63,
                 from include/linux/acpi.h:39,
                 from drivers/acpi/blacklist.c:33:
include/acpi/acpiosxf.h: In function ‘acpi_load_override_tables’:
include/acpi/acpiosxf.h:98: warning: no return statement in function
returning non-void
  CC      drivers/acpi/osl.o
In file included from include/acpi/acpi.h:63,
                 from include/linux/acpi.h:39,
                 from drivers/acpi/osl.c:40:
include/acpi/acpiosxf.h: In function ‘acpi_load_override_tables’:
include/acpi/acpiosxf.h:98: warning: no return statement in function
returning non-void
drivers/acpi/osl.c: At top level:
drivers/acpi/osl.c:514: error: redefinition of ‘acpi_load_override_tables’
include/acpi/acpiosxf.h:98: error: previous definition of
‘acpi_load_override_tables’ was here
make[2]: *** [drivers/acpi/osl.o] Error 1
make[1]: *** [drivers/acpi] Error 2
make: *** [drivers] Error 2

Thoughts, solutions, etc?

PS: please CC me as I'm not subscribed to the list.
