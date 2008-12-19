Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbYLSUXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYLSUXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYLSUXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:23:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:41986 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYLSUXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:23:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YWLx/+FqvMe/gjAFVjaDY0ityfXgzcwjQ8ykBBZZ1PttdzgZZSDLeIImbBHE6xErH6
         0kNhjXMEx32EKPpwJwJkAf03Y4F5Y4ilCSd5aVCI99Fw2aRuwYp2TPek7g5gA4jHXrrw
         kJNOPu6X4lqd0kREPLJW2h744N6Wyufv2hZ4I=
Message-ID: <3f9a31f40812191223g72b8a1eey2780f8e1a0ebf7aa@mail.gmail.com>
Date: Sat, 20 Dec 2008 01:53:38 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: martin@valinux.com, gareth@valinux.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Jaswinder Singh" <jaswinder@infradead.org>
Subject: Re: [PATCH] radeon_cp: use request_firmware
In-Reply-To: <1218095497.4016.3.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218095497.4016.3.camel@jaswinder.satnam>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Thu, Aug 7, 2008 at 1:21 PM, Jaswinder Singh <jaswinder@infradead.org> wrote:
> Moved datah before datal because datah is required before datal.
>
> Firmware blob looks like this...
>        __be32 datah
>        __be32 datal
>
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  drivers/gpu/drm/radeon/radeon_cp.c        |  152 ++-
>  drivers/gpu/drm/radeon/radeon_drv.h       |    6 +
>  drivers/gpu/drm/radeon/radeon_microcode.h | 1844 -----------------------------
>  firmware/Makefile                         |    4 +
>  firmware/WHENCE                           |   40 +
>  firmware/radeon/R100_cp.bin.ihex          |  130 ++
>  firmware/radeon/R200_cp.bin.ihex          |  130 ++
>  firmware/radeon/R300_cp.bin.ihex          |  130 ++
>  firmware/radeon/R420_cp.bin.ihex          |  130 ++
>  firmware/radeon/R520_cp.bin.ihex          |  130 ++
>  firmware/radeon/RS600_cp.bin.ihex         |  130 ++
>  firmware/radeon/RS690_cp.bin.ihex         |  130 ++
>  12 files changed, 1050 insertions(+), 1906 deletions(-)
>  delete mode 100644 drivers/gpu/drm/radeon/radeon_microcode.h
>  create mode 100644 firmware/radeon/R100_cp.bin.ihex
>  create mode 100644 firmware/radeon/R200_cp.bin.ihex
>  create mode 100644 firmware/radeon/R300_cp.bin.ihex
>  create mode 100644 firmware/radeon/R420_cp.bin.ihex
>  create mode 100644 firmware/radeon/R520_cp.bin.ihex
>  create mode 100644 firmware/radeon/RS600_cp.bin.ihex
>  create mode 100644 firmware/radeon/RS690_cp.bin.ihex
>

Is available at
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commit;h=3a911a216742e4ab998f3281409d46a62f252716


Please let me know, should I need to resend this patch for :
1. git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
OR
2. git kernel.org:/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Thank you,

Jaswinder Singh.
