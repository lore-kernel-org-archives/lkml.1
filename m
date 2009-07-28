Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZG1PSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZG1PSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZG1PSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:18:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60679 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbZG1PSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:18:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT 
 =?iso-8859-1?q?and=09DEVICE=5FOBJECT_typedefs_into_their_corresponding?=
 =?iso-8859-1?q?_structs?=
Date: Tue, 28 Jul 2009 17:18:31 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Nicolas Palix <npalix@diku.dk>, Greg KH <gregkh@suse.de>,
       hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200907281030.45317.npalix@diku.dk> <200907281701.43509.npalix@diku.dk> <20090728150716.GH3711@parisc-linux.org>
In-Reply-To: <20090728150716.GH3711@parisc-linux.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907281718.31681.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19MPrTAWIrwfaepj5ED6xBvCwspjZqlnKg0mNL
 WnuQvAQ40N3N80FtOw05NHdRo4AMxHc2Ipg1+Xd3Rh4+g3saRS
 jYCCPKeFojrXfU5t+TKqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Matthew Wilcox wrote:
> On Tue, Jul 28, 2009 at 05:01:42PM +0200, Nicolas Palix wrote:
> > Ok. So, I guess the pattern for the other typedef is to strip the _OBJECT
> > suffix when present, and always add the prefix hv_, right ?
> 
> The 'pattern' is to look at what the code is doing and choose a sensible
> name.

I took a closer look at how this is used and noticed that there
is both the DEVICE_OBJECT typedef and struct device_context.
While I don't understand the reason for the split, my feeling
is that the contents of DEVICE_OBJECT should really be moved into
device_context and that one be renamed to hv_device.

	Arnd <><
