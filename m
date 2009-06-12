Return-Path: <linux-kernel-owner+w=401wt.eu-S1764266AbZFLKxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764266AbZFLKxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbZFLKxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:53:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZFLKxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:53:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] tty: fix unused warning when TCGETX is not defined
Date: Fri, 12 Jun 2009 12:53:27 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <1244802468-13667-1-git-send-email-vapier@gentoo.org> <20090612113830.6c21dfc9@lxorguk.ukuu.org.uk> <8bd0f97a0906120345s61c7216cp1925f05f829a1c3a@mail.gmail.com>
In-Reply-To: <8bd0f97a0906120345s61c7216cp1925f05f829a1c3a@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906121253.28336.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/mW0ieGDKAtXBzlG0toG7aAof72wsDcZCGIcZ
 m7TdAg0DJUC4T2zOo02hkfIwA78oM8zR1DAhdNmmyHPhFRw5er
 5azJSlrL+W9Ng/2Q4zDXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Mike Frysinger wrote:
> TIOCGRS485
> TIOCSRS485
> TCGETX
> TCSETX
> TCSETXF
> TCSETXW

These can easily be added, as my patch does.

> TIOCGHAYESESP
> TIOCSHAYESESP

These two are better left out IMHO. TIOCGHAYESESP on half the architectures
has the same number as FIOQSIZE on the other half (including blackfin).
The only driver using it is ESPSERIAL, which is marked as broken and depending
on ISA, so you really don't care.

	Arnd <><
