Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbZG1Oap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbZG1Oap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZG1Oao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:30:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZG1Oao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:30:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and DEVICE_OBJECT typedefs into their corresponding structs
Date: Tue, 28 Jul 2009 16:30:39 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Nicolas Palix <npalix@diku.dk>, "gregkh@suse.de" <gregkh@suse.de>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200907281030.45317.npalix@diku.dk> <200907281540.31805.arnd@arndb.de> <12B00476-1E0D-46B1-8939-DD36A0C3D197@microsoft.com>
In-Reply-To: <12B00476-1E0D-46B1-8939-DD36A0C3D197@microsoft.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907281630.39684.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18KA/F/D1hjFeeXANz01TLlhvZzkJftSo0UQDi
 eCDALtMXmgF0ThR1qpM1wwzIZ7C0n60E1qFCIptf7xrkxVe7AY
 UIqkpqRBj4Nxof9Ih/kWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Hank Janssen wrote:
> Excellent suggestion. I will submit a patch to call it hv_vmbus_device
> which makes it even more clear.

Ok. IMHO it's also important to keep the name space consistent, so
if you name it hv_vmbus_device instead of vmbus_device, you should
consequently also rename all other vmbus_* names to hv_vmbus_*
in follow-on patches. If you don't plan to do that, I guess
vmbus_device is fine as well.

	Arnd <><
