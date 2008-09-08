Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYIHUej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYIHUej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYIHUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:34:31 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:2727 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYIHUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:34:30 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 fixes
Date: Mon, 8 Sep 2008 16:34:23 -0400
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org>
In-Reply-To: <200809081932.m88JWVZG013061@askone.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081634.24257.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 15:32, H. Peter Anvin wrote:
> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> index e372b58..b72b4f7 100644
> --- a/arch/x86/Makefile_32.cpu
> +++ b/arch/x86/Makefile_32.cpu
> @@ -45,3 +45,8 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
>  # cpu entries
>  cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
Peter, I'm getting this error:
as: unrecognized option `-mtune=generic32'
I have binutils 2.17.
David
