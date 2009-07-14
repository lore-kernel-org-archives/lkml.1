Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZGNNlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZGNNlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZGNNlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:41:07 -0400
Received: from compulab.site5.com ([67.18.134.219]:39304 "EHLO compulab.co.il"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbZGNNlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:41:06 -0400
Message-ID: <4A5C8AEF.60700@compulab.co.il>
Date: Tue, 14 Jul 2009 16:41:03 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: Re: Reboot quirk for sbc-fitpc2 board
References: <4A364942.8080802@compulab.co.il>
In-Reply-To: <4A364942.8080802@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any updates on this?

Denis Turischev wrote:
> Handle problems with rebooting on CompuLab SBC-FITPC2 board.
>
> Signed-off by Denis Turischev <denis@compulab.co.il>
>
> --- linux-2.6.30.orig/arch/x86/kernel/reboot.c  2009-06-15
> 15:34:49.000000000 +0300
> +++ linux-2.6.30/arch/x86/kernel/reboot.c       2009-06-15
> 15:37:07.000000000 +0300
> @@ -240,6 +240,14 @@
>                         DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
>                 },
>         },
> +       {       /* Handle problems with rebooting on CompuLab SBC-FITPC2
> board */
> +               .callback = set_bios_reboot,
> +               .ident = "CompuLab SBC-FITPC2",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
> +               },
> +       },
>         { }
>  };
>
>
>   

