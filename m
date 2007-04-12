Return-Path: <linux-kernel-owner+w=401wt.eu-S1750894AbXDLW60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbXDLW60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXDLW60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:58:26 -0400
Received: from gw.goop.org ([64.81.55.164]:49814 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbXDLW6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:58:25 -0400
Message-ID: <461EB96C.5060603@goop.org>
Date: Thu, 12 Apr 2007 15:57:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org> <20070412222547.GA11166@waste.org>
In-Reply-To: <20070412222547.GA11166@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, Apr 12, 2007 at 01:50:54PM -0700, Jeremy Fitzhardinge wrote:
>   
>> -#define HEAP_SIZE             0x3000
>> +#define HEAP_SIZE             0x4000
>>     
>
> There are a bunch more of these that'll need fixing.
>   

Like this?

diff -r 2ad8a0729f26 arch/alpha/boot/misc.c
--- a/arch/alpha/boot/misc.c	Thu Apr 12 13:44:02 2007 -0700
+++ b/arch/alpha/boot/misc.c	Thu Apr 12 15:48:43 2007 -0700
@@ -98,7 +98,7 @@ static ulg free_mem_ptr;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../lib/inflate.c"
 
diff -r 2ad8a0729f26 arch/arm/boot/compressed/misc.c
--- a/arch/arm/boot/compressed/misc.c	Thu Apr 12 13:44:02 2007 -0700
+++ b/arch/arm/boot/compressed/misc.c	Thu Apr 12 15:48:43 2007 -0700
@@ -239,7 +239,7 @@ static ulg free_mem_ptr;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../../lib/inflate.c"
 
diff -r 2ad8a0729f26 arch/arm26/boot/compressed/misc.c
--- a/arch/arm26/boot/compressed/misc.c	Thu Apr 12 13:44:02 2007 -0700
+++ b/arch/arm26/boot/compressed/misc.c	Thu Apr 12 15:48:43 2007 -0700
@@ -182,7 +182,7 @@ static ulg free_mem_ptr;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../../lib/inflate.c"
 
diff -r 2ad8a0729f26 arch/x86_64/boot/compressed/misc.c
--- a/arch/x86_64/boot/compressed/misc.c	Thu Apr 12 13:44:02 2007 -0700
+++ b/arch/x86_64/boot/compressed/misc.c	Thu Apr 12 15:48:43 2007 -0700
@@ -189,7 +189,7 @@ static long free_mem_ptr;
 static long free_mem_ptr;
 static long free_mem_end_ptr;
 
-#define HEAP_SIZE             0x6000
+#define HEAP_SIZE             0x7000
 
 static char *vidmem = (char *)0xb8000;
 static int vidport;

