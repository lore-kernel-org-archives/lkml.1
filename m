Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZFYKzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZFYKzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZFYKzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:55:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFYKzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:55:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] add checksum selftest
Date: Thu, 25 Jun 2009 12:55:06 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org> <200906241724.30947.arnd@arndb.de> <8bd0f97a0906241243k1d4a6d25x3216e940b356d2ca@mail.gmail.com>
In-Reply-To: <8bd0f97a0906241243k1d4a6d25x3216e940b356d2ca@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906251255.06984.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DGOGRbo9LpLCUP6IOgRluFpXIgsgtlTX5Jmk
 d/0TQ9PFHlCtJgH+HSaT5CYA/1+RoZar4EbSn6JdoHRCkXh4r3
 h73STDZEgTysVe5tUxG7hTSDJOir9+K
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Mike Frysinger wrote:
> ok, i can see that for the result, but how do i handle the functions
> that also take a __wsum ?  do i just always pass them 0 to avoid
> implementation issues ?

No, any __wsum you pass in there should be fine, because that one
gets folded in in the end.

	Arnd <><
