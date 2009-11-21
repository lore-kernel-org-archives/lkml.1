Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZKUVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZKUVP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 16:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZKUVPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 16:15:25 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64158 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbZKUVPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 16:15:25 -0500
Date: Sat, 21 Nov 2009 16:15:23 -0500 (EST)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Rusty Russell <rusty@rustcorp.com.au>
cc: =?ISO-8859-15?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Licensing on lib/bsearch.c?
In-Reply-To: <200911191903.04915.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0911211400110.14837@dr-wily.mit.edu>
References: <200911191903.04915.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Rusty Russell wrote:

> Hi Tim, Andre,
> 
>    I note that the license header on lib/bsearch.c is GPLv2.  I wanted to
> steal it for SAMBA, which is GPLv3.  This is one reason all my kernel code is
> v2 or later.
> 
> If you don't have strong objections, could you send something like the
> following so I don't have to reimplement and re-test?

Rusty,

I'd be happy to release it under a more permissive license.

	-Tim Abbott

bsearch: relicense under MIT/X11 license.

Rusty asked nicely.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 lib/bsearch.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/lib/bsearch.c b/lib/bsearch.c
index 4297c98..5555bb2 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -4,9 +4,25 @@
  * Copyright (C) 2008-2009 Ksplice, Inc.
  * Author: Tim Abbott <tabbott@ksplice.com>
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; version 2.
+ * Permission is hereby granted, free of charge, to any person
+ * obtaining a copy of this software and associated documentation files
+ * (the "Software"), to deal in the Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so,
+ * subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
  */
 
 #include <linux/module.h>
-- 
1.6.5.2

