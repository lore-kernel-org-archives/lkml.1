Return-Path: <linux-kernel-owner+w=401wt.eu-S965417AbXCFR6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbXCFR6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965416AbXCFR6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:58:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:46688 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419AbXCFR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f6F5EpebrksNJRnIj0E2IL0Aykomt8MOk0UKw9na4/g2Veet9c3ewYl5qFiJAPg4wUO5Q3ZAv0BXbelozVEbKYNQRahZ3E+ckP47O6LiEtYSMYdbNg14FZ8W4EobzMrBMLAn3WY+tEPQvKapNF0QudyQIMQOGoAjNA1/i1mEoto=
Message-ID: <9c21eeae0703060958o1c54c3a9x8645d106c4798266@mail.gmail.com>
Date: Tue, 6 Mar 2007 09:58:30 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "David M. Lloyd" <dmlloyd@flurg.com>
Subject: Re: [PATCH] remove availability for PAGE_SIZE and friends (i386)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1173200622.32480.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0703060831k1a99bd13k1bf81afaabb6f1af@mail.gmail.com>
	 <1173200622.32480.23.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pfft, did I seriously screw that up... (/me failed)

On 3/6/07, David M. Lloyd <dmlloyd@flurg.com> wrote:
> On Tue, 2007-03-06 at 08:31 -0800, David Brown wrote:
> > +#define __KERNEL__
>
> That's a #define, not an #ifdef...
>
> - DML
>
>

diff --git a/include/asm-i386/page.h b/include/asm-i386/page.h
index 7b19f45..a9eedd0 100644
--- a/include/asm-i386/page.h
+++ b/include/asm-i386/page.h
@@ -1,6 +1,8 @@
 #ifndef _I386_PAGE_H
 #define _I386_PAGE_H

+#ifdef __KERNEL__
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT     12
 #define PAGE_SIZE      (1UL << PAGE_SHIFT)
@@ -9,7 +11,6 @@
 #define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
 #define LARGE_PAGE_SIZE (1UL << PMD_SHIFT)

-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__



Revised patch.
