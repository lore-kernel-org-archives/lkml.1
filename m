Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZFRWbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZFRWbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZFRWbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:31:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:57618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZFRWbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:31:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 01/11] ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
Date: Fri, 19 Jun 2009 00:31:17 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <cover.1245345894.git.arnd@arndb.de> <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906190031.17786.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/lHd+lDUkpK18JrMO7zVAIuuUKMhcAzeuJxTB
 Vjz0Y/IkOMflKK9FTX0GPN/ZcAaZ8Kstna+J+HcY1oeZQipw/r
 WKSqtvmjXWTl5+SlTxz3XWQqXzM/VZo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 June 2009, Arnd Bergmann wrote:
> The definition of ipc_parse_version depends on
> __ARCH_WANT_IPC_PARSE_VERSION, but the header file
> declares it conditionally based on the architecture.
> 
> Use the macro consistently to make it easier to add
> new architectures.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Michal, you can ignore this one now, it just went in.

	Arnd <><
