Return-Path: <linux-kernel-owner+w=401wt.eu-S933708AbZJMHbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbZJMHbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933693AbZJMHbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:31:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933692AbZJMHbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:31:36 -0400
Date: Tue, 13 Oct 2009 09:30:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ehci-hcd: Fix typo in an error message
In-Reply-To: <1255412229-5996-1-git-send-email-ozan@pardus.org.tr>
Message-ID: <alpine.LSU.2.00.0910130930410.19284@wotan.suse.de>
References: <1255412229-5996-1-git-send-email-ozan@pardus.org.tr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1022438266-1255419059=:19284"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1022438266-1255419059=:19284
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 13 Oct 2009, Ozan Ça?layan wrote:

> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index 9835e07..a68eb2c 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -209,7 +209,7 @@ static int handshake_on_error_set_halt(struct ehci_hcd *ehci, void __iomem *ptr,
>  	if (error) {
>  		ehci_halt(ehci);
>  		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
> -		ehci_err(ehci, "force halt; handhake %p %08x %08x -> %d\n",
> +		ehci_err(ehci, "force halt; handshake %p %08x %08x -> %d\n",
>  			ptr, mask, done, error);
>  	}

Applied. thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-1022438266-1255419059=:19284--
