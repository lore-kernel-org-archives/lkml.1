Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbYFEQIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbYFEQIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYFEQIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:08:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbYFEQIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:08:16 -0400
Date: Thu, 5 Jun 2008 09:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vitaliy Ivanov" <vitalivanov@gmail.com>
Cc: torvalds@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       devzero@web.de, jsun@junsun.net, dwmw2@infradead.org,
       protasnb@gmail.com, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH resend] Adding dummy release functions to avoid
 warnings.
Message-Id: <20080605090725.96da4b75.akpm@linux-foundation.org>
In-Reply-To: <35fbaa3e0806050239y5987fc33rd349be8d07bc1262@mail.gmail.com>
References: <1208306056.15140.13.camel@pcvitaliy>
	<35fbaa3e0806050239y5987fc33rd349be8d07bc1262@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 12:39:46 +0300 "Vitaliy Ivanov" <vitalivanov@gmail.com> wrote:

> Hi all,
> 
> Natalie reported that patch wasn't accepted.
> Please check this out. If I need to correct it somehow then pls let me know.
> 
> V.
> 
> ---------- Forwarded message ----------
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Wed, Apr 16, 2008 at 3:34 AM
> Subject: [PATCH] Adding dummy release functions to avoid warnings.
> To: linux-kernel@vger.kernel.org, devzero@web.de, jsun@junsun.net,
> dwmw2@infradead.org
> 
> 
> 
> Subject: [PATCH] Adding dummy release functions to avoid warnings.
> 
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> 
> Trivial fix for #9690.
> Added simple release functions that doing nothing.
> Not sure whether we can leave it as is or to rework using
> platform_device helpers like platform_device_alloc.

Please see Documentation/kobject.txt - search for the text
"mocked mercilessly" :)

> This approach is used in many drivers.
> --
> 
>  drivers/mtd/maps/physmap.c |    6 ++++++

Let's mock David too!

>  drivers/video/hgafb.c      |   10 +++++++++-

I expect that
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch which I
merged yesterday will help here.

