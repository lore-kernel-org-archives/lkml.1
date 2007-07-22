Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXGVFPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXGVFPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXGVFPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:15:34 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:11160 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbXGVFPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kX27TKwxHkPMvRu2+uJ/Ja6f4DXuKI7nEihIysCB/IZwR8ID5XXLnxNuFN+Gh0iMoTwGD20Np9pTm0tEf6LQD4Dq66PUMG1RGXEMZSVHGYIG547XzvXxnU4TTro0CGEv1oRNfaYsS4UYmBubpKbsiD0KlkZVZVsvAG95/H1CMxY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [00/37] Clean up duplicate includes (resend patch 32)
Date: Sun, 22 Jul 2007 07:14:34 +0200
User-Agent: KMail/1.9.7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200707211701.23911.jesper.juhl@gmail.com> <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
In-Reply-To: <a781481a0707211930l7e712dedo474a5e9e44e84adc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220714.34433.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 04:30:41 Satyam Sharma wrote:
> On 7/21/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > [...]
> > These are the patches in this series :
> 
> Ok, I've reviewed all patches in this series except:
> 
> >  [PATCH][12/37] Clean up duplicate includes in drivers/net/
> >  [PATCH][28/37] Clean up duplicate includes in net/ipv4/
> >  [PATCH][32/37] Clean up duplicate includes in net/sunrpc/
> 

Here's 32 : 

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 4906975..794ce55 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -42,7 +42,6 @@
 #include <linux/pagemap.h>
 
 #include <linux/sunrpc/auth_gss.h>
-#include <linux/sunrpc/svcauth.h>
 #include <linux/sunrpc/gss_err.h>
 #include <linux/sunrpc/svcauth.h>
 #include <linux/sunrpc/svcauth_gss.h>
