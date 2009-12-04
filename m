Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbZLDW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbZLDW0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZLDW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:26:38 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:20273 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbZLDW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:26:37 -0500
Date: Fri, 4 Dec 2009 14:25:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Grozdan <neutrino8@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can't compile 2.6.32
Message-Id: <20091204142522.6de2c52e.randy.dunlap@oracle.com>
In-Reply-To: <c5bd819b0912040532x13b7e564ve7f37badb0aaa521@mail.gmail.com>
References: <c5bd819b0912040532x13b7e564ve7f37badb0aaa521@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B198CA0.0033:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 14:32:08 +0100 Grozdan wrote:

> Hello,
> 
> I'm having trouble trying to compile the 2.6.32 kernel on my openSUSE
> 11.1 system. While doing so, I see a lot of warnings which seem to
> come from include/acpi/acpiosxf.h and then when the compile process
> enters the drivers/acpi directory, it errors out with the following:
> 
>   CC      drivers/acpi/tables.o
> In file included from include/acpi/acpi.h:63,
>                  from include/linux/acpi.h:39,
>                  from drivers/acpi/tables.c:33:
> include/acpi/acpiosxf.h: In function ‘acpi_load_override_tables’:
> include/acpi/acpiosxf.h:98: warning: no return statement in function
> returning non-void
>   CC      drivers/acpi/blacklist.o
> In file included from include/acpi/acpi.h:63,
>                  from include/linux/acpi.h:39,
>                  from drivers/acpi/blacklist.c:33:
> include/acpi/acpiosxf.h: In function ‘acpi_load_override_tables’:
> include/acpi/acpiosxf.h:98: warning: no return statement in function
> returning non-void
>   CC      drivers/acpi/osl.o
> In file included from include/acpi/acpi.h:63,
>                  from include/linux/acpi.h:39,
>                  from drivers/acpi/osl.c:40:
> include/acpi/acpiosxf.h: In function ‘acpi_load_override_tables’:
> include/acpi/acpiosxf.h:98: warning: no return statement in function
> returning non-void
> drivers/acpi/osl.c: At top level:
> drivers/acpi/osl.c:514: error: redefinition of ‘acpi_load_override_tables’
> include/acpi/acpiosxf.h:98: error: previous definition of
> ‘acpi_load_override_tables’ was here
> make[2]: *** [drivers/acpi/osl.o] Error 1
> make[1]: *** [drivers/acpi] Error 2
> make: *** [drivers] Error 2
> 
> Thoughts, solutions, etc?

Please send your failing kernel .config file.  Thanks.


> PS: please CC me as I'm not subscribed to the list.
> --

---
~Randy
