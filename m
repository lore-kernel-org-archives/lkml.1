Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbXGYPjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbXGYPjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbXGYPji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:39:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:32304 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744AbXGYPjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eImakQnOsKXaz0bIDkm4zcjJOz5n0aAvhtN2GNnKDWFkyTjuwfGbdX61LEL2qv/Gwozo+eSQcrQJQ3N/xLrNImKmuJxJu5SXgDlfnyEUQqXFRrJNsbmoxNBajTwcifU7U6T/QQgnGyFJY5H4XS51jRMV/5/17NQr0De6GvnsJI8=
Message-ID: <ed10ee420707250839s60904507xb777b61c2d043bd@mail.gmail.com>
Date: Wed, 25 Jul 2007 08:39:36 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Cc: jschopp <jschopp@austin.ibm.com>, "Andy Whitcroft" <apw@shadowen.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Randy Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20070725011346.GA3572@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
	 <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org>
	 <20070724021526.3d92286b.akpm@linux-foundation.org>
	 <20070724172217.GA10725@linux-sh.org>
	 <Pine.LNX.4.64.0707242000120.18990@fbirervta.pbzchgretzou.qr>
	 <46A64587.2010704@shadowen.org> <20070724194901.GE6019@stusta.de>
	 <46A661FB.7040504@austin.ibm.com> <20070725011346.GA3572@stusta.de>
X-Google-Sender-Auth: 9c59fa0223341c21
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Adrian Bunk <bunk@stusta.de> wrote:

> There are more important things than exploiting the corner cases of
> codingstyle, e.g. could you teach checkpatch.pl to give exactly two
> errors for the following code?
>
>
>         while (a);
>                 for (b = 0; b < 50; b++);
>                         for (c = 0; c < sizeof(struct module); c++)
>                                 d = e;

There are three errors there.  The while (a) busy wait needs a cpu_relax()
or something, the first for is at the wrong level of indentation and the
second for is at the wrong level of indentation relative to the first one.
