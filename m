Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZBPKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZBPKdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZBPKdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:33:11 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:4188 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795AbZBPKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:33:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhcFAI/OmEnCTsYx/2dsb2JhbACBbs5LhBwG
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] UVC: uvc_status_cleanup(): undefined reference to `input_unregister_device'
Date: Mon, 16 Feb 2009 11:36:40 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28; KDE/4.2.0; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090208145835.GA1649@elte.hu> <200902150119.48355.laurent.pinchart@skynet.be> <49987418.40606@oracle.com>
In-Reply-To: <49987418.40606@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161136.41037.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009 20:59:20 Randy Dunlap wrote:
>
> This should allow INPUT=y or USB_VIDEO_CLASS=INPUT, i.e., they don't always
> have to match, in the case where INPUT=y and UVC=m (same problem exists
> with pwc in -mm & linux-next, btw.  PWC patch follows this one.).
>
>
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix build errors when USB_VIDEO_CLASS=y and INPUT=m.
> Fixes kernel bugzilla #12671.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>

Mauro, can you please apply ?

> ---
>  drivers/media/video/uvc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- mmotm-2009-0214-0049.orig/drivers/media/video/uvc/Kconfig
> +++ mmotm-2009-0214-0049/drivers/media/video/uvc/Kconfig
> @@ -9,7 +9,7 @@ config USB_VIDEO_CLASS
>  config USB_VIDEO_CLASS_INPUT_EVDEV
>  	bool "UVC input events device support"
>  	default y
> -	depends on USB_VIDEO_CLASS && INPUT
> +	depends on USB_VIDEO_CLASS=INPUT || INPUT=y
>  	---help---
>  	  This option makes USB Video Class devices register an input device
>  	  to report button events.

Laurent Pinchart

