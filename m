Return-Path: <linux-kernel-owner+w=401wt.eu-S1031194AbXDZMQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031194AbXDZMQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031201AbXDZMQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:16:11 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1657 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031194AbXDZMQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:16:10 -0400
Message-ID: <4630980D.7010904@shadowen.org>
Date: Thu, 26 Apr 2007 13:16:13 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting the following on an x86_64 numa box:

  CC      arch/x86_64/vdso/vclock_gettime.o
arch/x86_64/vdso/vclock_gettime.c:1: error: code model `small' not
supported in the 32 bit mode
make[1]: *** [arch/x86_64/vdso/vclock_gettime.o] Error 1
make: *** [arch/x86_64/vdso] Error 2

Kernel config here: http://test.kernel.org/abat/85358/build/dotconfig

-apw
