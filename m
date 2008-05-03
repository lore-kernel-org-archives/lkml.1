Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYECVFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYECVFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYECVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:05:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57084 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYECVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:05:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 1/2] OF: Fix coding style violation in of_device.c and of_platform.c
Date: Sat, 3 May 2008 23:04:57 +0200
User-Agent: KMail/1.9.9
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>
References: <monstr@seznam.cz> <1209824532-7939-1-git-send-email-monstr@seznam.cz> <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
In-Reply-To: <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805032304.58709.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19hSbuAem/TU8BE8sGSOcnQWntsG5bTyzt7vNx
 JJ0ucSby36B7Cq6Wi0UWHMn3Fo8khe07RXD/RE027BouybMtGb
 KTJSSUd+BxLDO9ZqL/sQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008, monstr@seznam.cz wrote:

>  
>  #include <asm/errno.h>
> +
> +#ifdef CONFIG_PPC_PSERIES
>  #include <asm/dcr.h>
> +#endif
>  

The patch looks basically good, but we normally try to not have an #include
inside of #ifdef. If the file builds without this #include, maybe you should
better leave it out entirely? Same for the ppc-pci.h in the other file.

	Arnd <><
