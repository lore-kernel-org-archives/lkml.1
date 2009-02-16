Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZBPWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZBPWwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZBPWwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:52:10 -0500
Received: from ozlabs.org ([203.10.76.45]:42476 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbZBPWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:52:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andreas Robinson <andr345@gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Tue, 17 Feb 2009 09:21:56 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
In-Reply-To: <1234722028-8110-1-git-send-email-andr345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170921.56789.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 04:50:22 Andreas Robinson wrote:
> Hi guys,
> 
> as you know, systems with custom kernels boot faster, since they don't
> need an initramfs or have to install modules. But, building a custom
> kernel it is not really practical if you are releasing a distro, for
> example.

Hi Andreas,

  This isn't crazy.  But you'd need to benchmark against the minimal
userspace solution: a binary with all the modules built into
it which calls sys_init_module on each one, then does the root swizzle
or whatever.

I think you'd find the difference to be in the noise.

Thanks,
Rusty.
