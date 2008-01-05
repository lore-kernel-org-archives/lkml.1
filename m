Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbYAEWKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbYAEWKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 17:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbYAEWKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 17:10:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51545 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbYAEWKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 17:10:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Can ARM use drivers/Kconfig [Was: Kconfig: Source "drivers/usb/gadget/Kconfig" for ARCH=arm]
Date: Sat, 5 Jan 2008 23:09:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Boldi <a1426z@gawab.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <200801051546.SAA08953@raad.intranet> <20080105192000.GA9553@uranus.ravnborg.org> <20080105203123.GA7797@flint.arm.linux.org.uk>
In-Reply-To: <20080105203123.GA7797@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801052309.25027.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19SFDOiz80Y0496E0B3Fe1rUozPbX1i4YSsAaI
 wUw1InTSBpqxhV9e2Qk3e+TjzOVupOPQTKuU9nGkrIvtyz1yvz
 p59Ul27aOE8WfRDRg4Ztw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 January 2008, Russell King wrote:
> Not everything in drivers/ is suitable for every ARM configuration.  It
> was felt at the time better for ARM to remain separate because people
> didn't want to pollute drivers/Kconfig with the ARM specific conditionals.

We made drivers/Kconfig work for s390 in the meantime, which is far more
special than arm in this regard, so I think you should try to give it
another go.

What are the main obstacles on arm that prevent you from building these
drivers?

	Arnd <><
