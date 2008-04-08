Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYDHAfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYDHAfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 20:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYDHAfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 20:35:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64524 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYDHAfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 20:35:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: joern@logfs.org
Subject: Re: [patch 3/15] fs/logfs/logfs.h
Date: Tue, 8 Apr 2008 02:35:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <20080401181308.512473173@logfs.org> <20080401181332.853833003@logfs.org>
In-Reply-To: <20080401181332.853833003@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804080235.28946.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1806r427uaB4ep2U7th2ZYnGOe29GNR0QxQzvH
 W2c+sw1mNrLor0+Ngq5YX88E+/Su7U/DbHZFRqpeYPfwP4xDqZ
 HHpNnOBjzdUZiT/EkapYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008, joern@logfs.org wrote:
> +/*
> + * Private errno for accessed beyond end-of-file.  Only used internally to
> + * logfs.  If this ever gets exposed to userspace or even other parts of the
> + * kernel, it is a bug.  256 was chosen as a number sufficiently above all
> + * used errno #defines.
> + *
> + * It can be argued that this is a hack and should be replaced with something
> + * else.  My last attempt to do this failed spectacularly and there are more
> + * urgent problems that users actually care about.  This will remain for the
> + * moment.  Patches are welcome, of course.
> + */
> +#define EOF                    (512)
> +

Try to make the comment match the definition, it still says the value is 256.

	Arnd <><
