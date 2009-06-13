Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbZFMWol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbZFMWol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbZFMWod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:44:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZFMWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:44:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 01/27] score: create Kconfig Kconfig.debug Makefile
Date: Sun, 14 Jun 2009 00:44:03 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF2086513E.4B4F803C-ON482575D0.0022E294-482575D0.0023688F@sunplusct.com>
In-Reply-To: <OF2086513E.4B4F803C-ON482575D0.0022E294-482575D0.0023688F@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906140044.04440.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Wbu9DJpGUksxqmIpjEgWZxVZVKHo9STLteyc
 QbzxCB5y+PxPv6/4vuev+0wTjBKNCtTrHy4bskS9jkUCOVLOoN
 VOvsO3eHUbs+dlZdcET+3V7Q/0lWdZ4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> +
> +config MMU
> +       bool
> +       default y
> +

After reading through the code again, I came across this defintion, which
confused me a bit. The source code clearly assumes a NOMMU architecture, but
this one enables the kernel support for MMU.

Is MMU support something that you plan to add later and is possible with
the hardware, or is this one wrong?

	Arnd <><
