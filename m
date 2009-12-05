Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZLECE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZLECE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZLECE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:04:58 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:33685 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZLECE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:04:57 -0500
MIME-Version: 1.0
Message-ID: <173abc14-0cbc-4340-b21f-3e8bc15f02dd@default>
Date: Fri, 4 Dec 2009 18:03:21 -0800 (PST)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <neutrino8@gmail.com>
Cc: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Can't compile 2.6.32
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B19BFCB.00EC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A bit more info on this. It seems there's a
CONFIG_ACPI_CUSTOM_OVERRIDE_INITRAMFS in the "normal" SUSE source RPM
package (which in my config is not enabled, but there is an option for
that) and looking at the drivers/acpi/osl.c and the
include/acpi/acpiosxf.h file, there's a define for this in the header
which has acpi_load_override_tables(void); and also this is present in
the osl.c file.... see both attachments. I could not find the same
thing in the kernel-default-vanilla source RPM package also present in
the repo.

~~~~~~~~~~~~~~~~~~  reply: ~~~~~~~~~~~~~~~~~~~~~~~~

You should take this up with the OpenSUSE people, not lkml.

Thanks,
~Randy
