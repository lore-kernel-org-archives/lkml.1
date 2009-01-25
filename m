Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZAYKbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZAYKbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 05:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZAYKav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 05:30:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:55025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZAYKav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 05:30:51 -0500
Subject: Re: building custom module on 2.6.28 fails
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <93655eb70901250037k79286904oc859118946155766@mail.gmail.com>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
	 <1232866165.3195.1.camel@localhost.localdomain>
	 <93655eb70901250037k79286904oc859118946155766@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 16:00:36 +0530
Message-Id: <1232879436.4303.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2009-01-25 at 14:07 +0530, Satish Eerpini wrote:
> -rw-r--r-- 1 root root 4848 2008-10-10 03:43
> /usr/src/kernels/linux-2.6.28/include/linux/bootmem.h
> -rw-r--r-- 1 root root  261 2008-10-10 03:43
> /usr/src/kernels/linux-2.6.28/include/linux/bottom_half.h
> -rw-r--r-- 1 root root  224 2009-01-25 14:09
> /usr/src/kernels/linux-2.6.28/include/linux/bounds.h
> 
> 
> On 1/25/09, Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > On Sun, 2009-01-25 at 10:27 +0530, Satish Eerpini wrote:
> >> include/linux/mmzone.h:18:26: error: linux/bounds.h: No such file or
> >> directory

It seems you run "make clean" or "make distclean" in your kernel sources

run "make prepare" in your kernel sources then you will not get this error.

--
JSR

