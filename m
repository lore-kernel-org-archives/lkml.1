Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbYLAHqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbYLAHqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYLAHqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:46:23 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:46430 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYLAHqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:46:22 -0500
Date: Mon, 1 Dec 2008 08:41:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/misc/Makefile, Kconfig: cleanup
Message-ID: <20081201074148.GA22463@uranus.ravnborg.org>
References: <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au> <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain> <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain> <alpine.LFD.2.00.0811281706540.24773@localhost.localdomain> <20081128223533.GA5175@uranus.ravnborg.org> <alpine.LFD.2.00.0811281801520.24773@localhost.localdomain> <20081129073816.GB8351@uranus.ravnborg.org> <alpine.LFD.2.00.0812010053100.3314@localhost.localdomain> <alpine.LFD.2.00.0812010102340.3314@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812010102340.3314@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len.

> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 817f7f5..bcde73b 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -1,9 +1,6 @@
>  #
>  # Makefile for misc devices that really don't fit anywhere else.
>  #
> -obj- := misc.o	# Dummy rule to force built-in.o to be made
> -
> -obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 ^^
Was this on purpose?
I do not think so...

	Sam
