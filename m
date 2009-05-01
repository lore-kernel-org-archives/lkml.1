Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbZEANUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbZEANUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbZEANUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:20:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760319AbZEANUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:20:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Date: Fri, 1 May 2009 15:20:33 +0200
User-Agent: KMail/1.9.9
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
       linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <200905011453.32006.arnd@arndb.de> <20090501141414.4adfe4ab@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501141414.4adfe4ab@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011520.34097.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX199ocAvsLA8CqB8KUKxNwpyJ616Bh+DoeQZcuE
 wgP4STO1DXQGUp++rOm/4Q0IO2EfNhM368l/jv4kXLXcxS52N4
 GT5d7Sdkfd3NDKwCvF75A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Alan Cox wrote:
> Currently if you create a new architecture you have to figure out what
> your equivalent tick rate is or you get an error for not defining it.
> Ditto if you try to build code using it on platforms that it is
> meaningless (eg S/390) you get an error.
> 
> You'd lose that rather useful property.

In that case, I still think it would be good to have it in asm-generic.
Half the architectures define it in this way currently, and new architectures
would still have to think about it before falling back on the default.

	Arnd <><
