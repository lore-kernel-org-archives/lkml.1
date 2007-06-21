Return-Path: <linux-kernel-owner+w=401wt.eu-S1751557AbXFUWw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbXFUWw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 18:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXFUWwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 18:52:43 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:47949 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbXFUWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 18:52:37 -0400
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 18:52:36 EDT
Date: Fri, 22 Jun 2007 00:32:03 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: schilling@fokus.fraunhofer.de
Cc: linux-kernel@vger.kernel.org
Subject: Linux Kernel include files
Message-ID: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

you might know that since ~ 2 years, the Sun Studio compilers
are available for Linux. Given the fact that they typically produce
faster code than GCC and that they offer more debug/optimizing features,
they are worth testing.

While it is no problem to use Sun Studio for non-Linux-specific programs,
it is impossible to compile programs using Sun Studio if these programs offer
Linux specific features.

Star ftp://ftp.berlios.de/pub/star/alpha/ offers support for archiving ext2
file flags. If star is compiled using Sun Studio, star's autoconfiguration will 
disable support for the Linux specific features because it detects "broken" 
include files.

Cdrtools ftp://ftp.berlios.de/pub/cdrecord/alpha/ offer support for an OS 
dependent SCSI transport. Cdrtools cannot be compiled wihout support for SCSI 
transport, so it is impossible to use Sun Studio to compile cdrtools.

Why does this happen?

Well, the reason is that in order to support Linux specific features, you need 
to include Linux specific include files (the Linux kernel include files). As 
these include files are currently not written in vanilla (ANSI) C but in a 
GCC-C-variant, other compilers do not like these include files.

Is there some hope that at least the Linux kernel interface definition files and
everything recursively included from these files will be rewritten in vanilla 
ANSI C?

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
