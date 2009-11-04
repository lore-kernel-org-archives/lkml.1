Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbZKDFrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbZKDFrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 00:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZKDFrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 00:47:22 -0500
Received: from mail.infogain.com ([65.223.106.147]:24145 "EHLO
	mail.infogain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZKDFrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 00:47:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: why kernel implement "udelay" by cpu instructions?
Date: Wed, 4 Nov 2009 11:15:01 +0530
Message-ID: <C86899CCB10A6C4E93D5978DCB232D4B0D7C0DFE@GDCMX01.igglobal.com>
In-Reply-To: <3e8340490911032136x56696cc3u3b6f3b1e5d132324@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: why kernel implement "udelay" by cpu instructions?
Thread-Index: AcpdEKHBSZ0pOG6GT3eMJZjqYq/rcQAAR9Tg
References: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com> <4AEE63E2.9010003@redhat.com> <3a665c760911031819t2fef1720q3e2f542a2e56a3d0@mail.gmail.com> <C86899CCB10A6C4E93D5978DCB232D4B0D754B62@GDCMX01.igglobal.com> <3e8340490911032136x56696cc3u3b6f3b1e5d132324@mail.gmail.com>
From: "Rajat Jain" <Rajat.Jain@infogain.com>
To: "Bryan Donlan" <bdonlan@gmail.com>
Cc: "loody" <miloody@gmail.com>, "Rik van Riel" <riel@redhat.com>,
       <linux-kernel@vger.kernel.org>,
       "Kernel Newbies" <kernelnewbies@nl.linux.org>
X-OriginalArrivalTime: 04 Nov 2009 05:45:44.0976 (UTC) FILETIME=[0D70A100:01CA5D12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> 
> I thought hrtimers allow higher-precision wakeups these days?
> Of course, if you only want to sleep for a few microseconds, the
> context switch might take longer than you want to sleep...

Yes, that is right. Sorry, I missed that. But that is purely HW
dependent - if your HW providea a high precision timer (Such as HPET on
latest Intel machines), that can be used for quicker sleeps.

Thanks,

Rajat
