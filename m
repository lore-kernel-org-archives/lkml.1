Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbXECLgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbXECLgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030413AbXECLgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:36:49 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38210 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXECLgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:36:48 -0400
Message-ID: <4639C91C.9070204@s5r6.in-berlin.de>
Date: Thu, 03 May 2007 13:35:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: dead CONFIG_ variables:  drivers/scsi/
References: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain> <20070503111113.GC12018@flint.arm.linux.org.uk> <Pine.LNX.4.64.0705030713210.680@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705030713210.680@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
[...]
>> > drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
>> > drivers/scsi/arm/acornscsi.c:169:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
[...]
> p.s.  "CONFIG_" prefix aside, i would think it's also a bit yucky to
> be checking for the definition of a preprocessor symbol that you've
> already hardcoded out of existence in the same source file.  :-)

These are basically #if 0 ... #endif blocks with an activation switch
conveniently placed at the top of the .c file.  In the quoted example,
the effect of the activation switch is also documented by a comment.

Of course we should restrain ourselves WRT the use of #if 0 ... #endif
blocks in in-tree code, but sometimes they have sensible applications.
-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
