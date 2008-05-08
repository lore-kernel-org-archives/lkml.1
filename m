Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYEHAzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYEHAzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYEHAyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:54:53 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:63854 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbYEHAyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:54:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver
Date: Thu, 8 May 2008 08:54:49 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67843@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080507162118.45ba52bb@core>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: AciwWiXDFCc7C7lqSt2HhtVM8N39kAAS8oxA
From: <JosephChan@via.com.tw>
To: <alan@lxorguk.ukuu.org.uk>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2008 00:54:50.0960 (UTC) FILETIME=[1EE76500:01C8B0A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thanks for your reviewing, 
I will push our engineers to check those things your mentioned and suggested.

BRs,
Joseph Chan 

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Wednesday, May 07, 2008 11:21 PM
To: Joseph Chan
Cc: Joseph Chan; akpm@linux-foundation.org; geert@linux-m68k.org; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver

> +void delays(int count);
> +void i2cWriteSdaScl(u8 sda, u8 scl);
> +void i2cWriteScl(u8 scl);
> +void i2cReadSdaScl(u8 *pSda, u8 *pScl);

Style is good, code looks clean

One big thing that needs fixing here is the function names. If the driver gets linked into the kernel then the symbols become global - and names like enableGPIO are asking for clashes. The viafb code is fine as it uses viafb_ as the function names. Possibly the helper functions should doo something similar.

We also have a generic i2c layer that might be usable but that is something that could be addressed in the future and isn't really an important detail.

>

