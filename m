Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYLaQ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYLaQ6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYLaQ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:58:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbYLaQ6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:58:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Wed, 31 Dec 2008 17:58:03 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1230363816-24097-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812311758.04516.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19i8Sl15G2+O97kNyEKL+61XQLyN8Es4kFKak2
 8u6vOWSVrrN8hqqdarveBvXECOuToA2VdPIYcDCrfvTde0LGl7
 TZrun3Y+kjxJpWWEDpK8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 December 2008, Mike Frysinger wrote:
> +
> +sub check_prototypes
> +{
> +       if ($line =~ m/^\s*extern\b/) {
> +               printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
> +               $ret = 1;
> +       }
> +}

Unfortunately, this way you can only detect prototypes with an explicit
'extern' in them, not the equivalent form with an implicit extern.

Not sure if we can detect the other form reliably from perl.

	Arnd <><
