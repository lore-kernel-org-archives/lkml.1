Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXEFMHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXEFMHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 08:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXEFMHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 08:07:07 -0400
Received: from ozlabs.org ([203.10.76.45]:45162 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbXEFMHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 08:07:06 -0400
Subject: Kconfig text confusion: Battery Class Support?
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 06 May 2007 22:06:52 +1000
Message-Id: <1178453212.7731.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	I know writing decent Kconfig help entries is an obscure art, but can
we please try harder to make the help, y'know, helpful?  See below for
my experience with 2.6.21-mm1.

	How come the Kconfig help for EXTERNAL_POWER says "is mandatory for
battery class support" and I still get prompted for "Battery class
support" when I say N?

	How come both these entries are of form "Foo (FOO)? -- Say Y here to
enable foo."?   Shouldn't we assume the reader knows what Y means?

How about:

        Battery class support (BATTERY) [N/m/y/?] (NEW) ?     
        
        This allows battery monitoring by userspace via sysfs (if
        available) and/or APM kernel interface (if selected below).  Say
        Y or M if building a kernel for a laptop.

I don't even understand the CONFIG_EXTERNAL_POWER enough to comment on
that one 8(

Rusty.
==
*
* External power support
*
External power kernel interface (EXTERNAL_POWER) [N/m/y/?] (NEW) ?

Say Y here to enable kernel external power detection interface,
like AC or USB. Information also will exported to userspace via
/sys/class/external_power/ directory.

This interface is mandatory for battery class support.

External power kernel interface (EXTERNAL_POWER) [N/m/y/?] (NEW) 
*
* Battery devices
*
Battery class support (BATTERY) [N/m/y/?] (NEW) ?     

Say Y here to enable battery class support. This allows battery
monitoring by userspace via sysfs (if available) and/or APM
kernel interface (if selected below).

Battery class support (BATTERY) [N/m/y/?] 

