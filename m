Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZFEMcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZFEMcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZFEMbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:31:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZFEMbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:31:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch] kbuild: fix headers_check.pl
Date: Fri, 5 Jun 2009 13:31:14 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org
References: <20090605021419.7905.89870.sendpatchset@localhost.localdomain> <200906051021.51726.arnd@arndb.de> <4A28F1CD.6040804@redhat.com>
In-Reply-To: <4A28F1CD.6040804@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906051331.14978.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX183vQu5LvnD4cDYRPHi+JfXRcIau/NJOTJKdoh
 C0SlrWyyiMOpZ3ty8Zzv3P6+We7sOyi9DT6EhgSfCzT+iBgVKS
 PwnceVbbmUXepLAMXx8JzVeDmdCdDbl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Amerigo Wang wrote:
> 
> >
> > I don't think we really need that distinction here, the old
> > text applies to both.
>
> Even for function declarations?

Yes. Any use of 'extern' in a kernel header file by definition
refers to a symbol that is defined in the kernel and therefore
not accessibly in user space. It is the same problem for
variables and functions, with the complication that leaving
out the 'extern' statement on a function declaration will
hide it from this check, while leaving it out on a variable
declaration turns it into a definition.

	Arnd <><
