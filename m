Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYH2RjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYH2RjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYH2Ri5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:38:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYH2Ri4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:38:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
Date: Fri, 29 Aug 2008 19:38:25 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>, dbrownell@users.sourceforge.net,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>, Li Yang <leoli@freescale.com>
References: <Pine.LNX.4.44L0.0808291307050.4447-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808291307050.4447-100000@netrider.rowland.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808291938.26651.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/nLSOinjxcqfOfz9OnojkpQo+TpZQcBVaAHe4
 iF0lcQao1/FcYZ5EbPi3DzzK4ilVZgX83LIgiElkJiqz7SR3nY
 KxHxt0JJqDB8ESIFbHosA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Alan Stern wrote:
> I thought you _were_ arguing against that.  Unless I misunderstood,
> your original complaint was that since each peripheral controller
> driver defines usb_gadget_{un}register_driver, there can be only one
> controller driver loaded at a time.

That's probably where the misunderstanding came from: I did not expect
more than one driver to actually be useful on a given system, but that
should IMHO not prevent you from loading the drivers using modprobe, or
building them all into the kernel.

	Arnd <><
