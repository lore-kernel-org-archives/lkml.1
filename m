Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZGTXqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZGTXqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZGTXqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:46:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:62513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZGTXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:46:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 34/54] Staging: hv: remove STRUCT_PACKED and STRUCT_ALIGNED defines
Date: Tue, 21 Jul 2009 01:46:41 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>, shemminger@linux-foundation.org
References: <20090717180850.873962925@mini.kroah.org> <20090717180921.448023599@mini.kroah.org>
In-Reply-To: <20090717180921.448023599@mini.kroah.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907210146.41399.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19yrYOI60Qc25yXsYEq8skloNkbgSaKoNsAkOE
 RQFfy63LE5HWG2z5sbk9SATY/b6IFWYbx7b1dVJyVV9wgqHB68
 bCpCFDu7LJjAyLs/8TsDr5Vl+pirQ5N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> @@ -43,7 +43,7 @@ typedef struct _RING_BUFFER {
>         // volatile u32 InterruptMask;
>         // Ring data starts here + RingDataStartOffset !!! DO NOT place any fields below this !!!
>      u8         Buffer[0];
> -} STRUCT_PACKED RING_BUFFER;
> +} __attribute__((packed)) RING_BUFFER;
>  

The data structure is actually packed already, the attribute does not make it better
and could be removed. We also have __packed as a shortcut for __attribute__((packed)).

	Arnd <><
