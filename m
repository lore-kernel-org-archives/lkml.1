Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbXCHPUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbXCHPUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXCHPUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:20:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:22666 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXCHPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:20:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tleN0rmMYXy55w0sW7B+4v27QZ0n8dYqv2kFyPeh9EcABq5kWS/ygjRivn+km5ObrMMR64ytHsHPjedlyXeHMRnKb1e/2ix/UfPx2QZshx3xMOlSiJd3+BpmzWQiNhjHJ1sMl+zSFclxZ94d+awRZ9wjigT5rGfo5E2/QS9w/JA=
Message-ID: <b6a2187b0703080720j6505f2f1sc7a7f2523c1f9513@mail.gmail.com>
Date: Thu, 8 Mar 2007 23:20:38 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: albcamus <albcamus@gmail.com>
Subject: Re: Linux v2.6.20-rc5
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Andrew Morton" <akpm@osdl.org>, "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <df9815e70703080015o2cd2dffelc36abfc76278f122@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701141858490.7122@boston.corp.fedex.com>
	 <20070114125648.GV7469@stusta.de>
	 <b6a2187b0701140546ne0b95d8q7aff70d93ffabb9@mail.gmail.com>
	 <df9815e70703080015o2cd2dffelc36abfc76278f122@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, albcamus <albcamus@gmail.com> wrote:
> I guess that it is because 'paravirt_ops' was exported as GPL symbol, whereas
> the vmware module doen't declare any license.
>
> I tried to add the following line:
>
> MODULE_LICENSE("GPL");
>
> into vmmon.tar and vmnet.tar under /usr/lib/vmare/modules/source/,
> then it works.


I'll try that. Thanks. Here's what I did, but don't know whether it's
the right approach (but, at least vmware still works) ...

Thanks,
Jeff.


--- vmware/vmmon-only/include/driver-config.h.org       2007-01-26
10:46:01 +0800
+++ vmware/vmmon-only/include/driver-config.h   2006-11-14 05:06:18 +0800
@@ -19,7 +19,8 @@
 #include "includeCheck.h"

 #include <linux/autoconf.h>
+#undef CONFIG_PARAVIRT
 #include "compat_version.h"

 /* We rely on Kernel Module support.  Check here. */
