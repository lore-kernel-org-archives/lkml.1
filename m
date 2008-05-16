Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbYEPUxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbYEPUxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYEPUxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:53:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39351 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYEPUxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:53:30 -0400
Date: Fri, 16 May 2008 13:52:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
 reference to `request_firmware'
Message-Id: <20080516135225.e6f8b2c7.randy.dunlap@oracle.com>
In-Reply-To: <200805162230.41350.rjw@sisk.pl>
References: <200805161906.19321.toralf.foerster@gmx.de>
	<200805162230.41350.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 22:30:40 +0200 Rafael J. Wysocki wrote:

> On Friday, 16 of May 2008, Toralf Förster wrote:
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      vmlinux
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33bab): undefined reference to `request_firmware'
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33c3f): undefined reference to `release_firmware'
> > make: *** [vmlinux] Error 1
> > 
> > The build was made with :
> > $>make randconfig; make clean; make
> 
> Is it the same as http://bugzilla.kernel.org/show_bug.cgi?id=10707 ?

It's in a different driver.

---
~Randy
