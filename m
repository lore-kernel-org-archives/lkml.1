Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYFCR1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYFCR1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYFCR04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:26:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:65419 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYFCR0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:26:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [RFC 2/3] virtio_console: use virtqueue notification for hvc_console
Date: Tue, 3 Jun 2008 19:24:41 +0200
User-Agent: KMail/1.9.9
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806031446.15330.borntraeger@de.ibm.com>
In-Reply-To: <200806031446.15330.borntraeger@de.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031924.42464.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/OZmcssEvMJP25iVDWa7uQoB7zeQFwASRgIh+
 Q7IbkolQnypZd0PnRV/eunG9IgWsyZh+diSD0R+0ctKWNiHKUF
 YbC2PtWFYLskX5Eie4d6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008, Christian Borntraeger wrote:
>  
> +/* The hvc device */
> +struct hvc_struct *hvc;
> +

I guess this should be static, a three letter identifier for a global variable
is not really unique.

	Arnd <><
