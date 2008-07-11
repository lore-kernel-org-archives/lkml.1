Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYGKJWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYGKJWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYGKJWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:22:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:56001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYGKJWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:22:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: Re: [PATCH] ioctl conversion
Date: Fri, 11 Jul 2008 11:22:30 +0200
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <6d291e080807101728j62be7c93qba11aa214a8dfe1@mail.gmail.com> <200807111008.21497.arnd@arndb.de> <6d291e080807110121t203c7cd0v9c84fb087cd75aa0@mail.gmail.com>
In-Reply-To: <6d291e080807110121t203c7cd0v9c84fb087cd75aa0@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111122.31384.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+pw4Tj84UjSLhLZCEwhOpqNSIExBjyMHudM5V
 WvbR6e9knpB3Rdkm1KwI0BRyHhaDpqGeQ4VTMCBsrVi4Vdys5J
 5eajsyQgnWwlJfcluYYhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008, Stoyan Gaydarov wrote:

> This would work normally but there are three early returns and the
> rest are just switch statements that set the return code.

I just looked at linux-next and found that Rafael has already done
the conversion from BKL to his own mutex, after Alan has introduced
the BKL in an earlier patch. Your patch is not needed any more.

It's good to look into the state of the ioctl conversion, but you
should make sure that you're not doing work that has already been
done by someone else, so try checking out linux-next first.

	Arnd <><
