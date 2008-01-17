Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYAQMTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYAQMTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYAQMTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:19:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:55224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYAQMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:19:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
Date: Thu, 17 Jan 2008 13:18:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx> <200801171254.04071.arnd@arndb.de> <87myr4ek82.fsf@barad-dur.regala.cx>
In-Reply-To: <87myr4ek82.fsf@barad-dur.regala.cx>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171318.57491.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1855Lu5yQbaCIf/bz84d/92BJqqa0ottzxDzX7
 aUZ8Dy6lrJyilsRzkLmlbvHfOFoD5luGZgwAlpqO4Z9ktF6pnq
 8Wiup9PklNcquI2e2XXHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, Mathieu SEGAUD wrote:
> yep, they do. I noticed this nested calls. I guess I will add
> _extX_compat_ioctl() running with no BKL's which would be used by both
> extX_ioctl() and extX_compat_ioctl().
> Any comments on such a strategy ? thanks a lot for the reminder :)
> 

Why not just kill the lock_kernel() in extX_compat_ioctl()?

	Arnd <><
