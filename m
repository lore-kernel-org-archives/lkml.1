Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZACAKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZACAKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZACAKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:10:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:58747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbZACAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:10:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Sat, 3 Jan 2009 01:09:57 +0100
User-Agent: KMail/1.9.9
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <200901030059.18438.arnd@arndb.de> <20090102160525.430c59f9@infradead.org>
In-Reply-To: <20090102160525.430c59f9@infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901030109.58197.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19eVVyUlD+CwWRRtzAuOEEco5Tng3OTxBPBgB9
 NPlOuAJNI1OD2MUVUQP/l5rJP29uAzpkJ51UBg87CohLIO4u7S
 rS6H2YNaUGz+08eED2edw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009, Arjan van de Ven wrote:
> in addition... what business does the kernel have to provide function
> prototypes to userspace, other than the system call prototypes?

This is the point I raised in my initial comment: we should warn about
all of them if possible. Note that the syscalls.h file is not even
exported. I can't think of a single case where a function protoype
should be exported from the kernel to user space. 

	Arnd <><
