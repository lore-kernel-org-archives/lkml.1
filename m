Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZHNMWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZHNMWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZHNMWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:22:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbZHNMWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:22:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 2/6] new kfifo API v0.3 - Cleanup namespace
Date: Fri, 14 Aug 2009 14:22:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
References: <1250250207.19690.93.camel@wall-e>
In-Reply-To: <1250250207.19690.93.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141422.40547.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18vO/SVaOe3sPU1H+v18+E/N+2PbuOC/xEMkQa
 Cluv9D2y2LPzHEAdcPHSdrZScgiAKoOwd0Muqx532mfQF+8xEW
 b1yNzbjiAraF6K92qY6UQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Stefani Seibold wrote:
> This is patch 2/6 of the new kfifo API:
>  rename all __kfifo_* into kfifo_*

explanation is missing again

>  drivers/char/nozomi.c                       |   12 +++++-----
>  drivers/infiniband/hw/cxgb3/cxio_resource.c |   10 ++++----
>  drivers/net/wireless/libertas/cmd.c         |    4 +--
>  drivers/net/wireless/libertas/main.c        |    8 +++----
>  drivers/platform/x86/sony-laptop.c          |    2 -
>  drivers/scsi/libiscsi.c                     |   14 ++++++------
>  drivers/scsi/libiscsi_tcp.c                 |   20 ++++++++---------
>  drivers/scsi/libsrp.c                       |    2 -
>  drivers/usb/host/fhci.h                     |    6 ++---
>  include/linux/kfifo.h                       |   32 ++++++----------------------
>  kernel/kfifo.c                              |   12 +++++-----
>  net/dccp/probe.c                            |    2 -
>  12 files changed, 53 insertions(+), 71 deletions(-)
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

(Contents)
Acked-by: Arnd Bergmann <arnd@arndb.de>
