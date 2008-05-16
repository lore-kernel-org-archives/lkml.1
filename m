Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbYEPUas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbYEPUas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYEPUai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:30:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbYEPUah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:30:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined reference to `request_firmware'
Date: Fri, 16 May 2008 22:30:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <200805161906.19321.toralf.foerster@gmx.de>
In-Reply-To: <200805161906.19321.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805162230.41350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 of May 2008, Toralf Förster wrote:
> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33bab): undefined reference to `request_firmware'
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33c3f): undefined reference to `release_firmware'
> make: *** [vmlinux] Error 1
> 
> The build was made with :
> $>make randconfig; make clean; make

Is it the same as http://bugzilla.kernel.org/show_bug.cgi?id=10707 ?

Rafael
