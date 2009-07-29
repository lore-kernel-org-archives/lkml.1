Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZG2NIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZG2NIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZG2NIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:08:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZG2NIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:08:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Palix <npalix@diku.dk>
Subject: Re: [PATCH 4/4] Staging: hv: Fix warning by casting a (const void *) to (void *)
Date: Wed, 29 Jul 2009 15:08:24 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: gregkh@suse.de, hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200907291410.29355.npalix@diku.dk>
In-Reply-To: <200907291410.29355.npalix@diku.dk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907291508.24608.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18nQ5O/hNVq7aQxkCCzf8iYZYr9slPc8doXFUu
 cSS1lGRSO1UttmqecI9eWJGoMT9TZ3Wo4A7wa5eHBqbnm3UNcT
 l8nSNrwAxBhKwTtxAL3Yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Nicolas Palix wrote:
> Fix compilation warning by casting the const void *Buffer
> variable into a void *.
> 
> Signed-off-by: Nicolas Palix <npalix@diku.dk>

Not sure if this one is worthwhile. Replacing SG_BUFFER_LIST
with the existing struct scatterlist might be a better
fix, as sg_set_buf() does not generate a warning like this
anyway.

	Arnd <><
