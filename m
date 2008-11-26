Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYKZRdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYKZRdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYKZRda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:33:30 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:26278 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751796AbYKZRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:33:29 -0500
Message-ID: <492D8863.1000104@panasas.com>
Date: Wed, 26 Nov 2008 19:33:23 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: open-osd development <osd-dev@open-osd.org>
CC: Torben Mathiasen <device@lanana.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH 01/18] major.h: char-major number for OSD device
 driver
References: <491073BB.4000900@panasas.com> <1225815420-5721-1-git-send-email-bharrosh@panasas.com>
In-Reply-To: <1225815420-5721-1-git-send-email-bharrosh@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2008 17:32:02.0196 (UTC) FILETIME=[E48AFD40:01C94FEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> We need a major for a char device for our OSD device driver.
> Attached is a proposed patch for the Documentation/devices.txt
> and include/linux/major.h files.
> 
> I have allocated the *260* char device as it looked like the next
> available on the lanana.org web-site
> (http://lanana.org/docs/device-list/devices-2.6+.txt)
> 
> Any number will do. Please allocate a number for us
> 
> (See http:/open-osd.org for further information)
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> CC: Torben Mathiasen <device@lanana.org>

Hi Torben Mathiasen

The maintainers file as well as the lanana.org website only states
this <device@lanana.org> email address. I hope it is the right one.

Please you have not confirmed or revoked my ability to use 260 
as a Major for a new char-device. Please review

What git tree should this go through?

Thanks 
Boaz

> ---
>  Documentation/devices.txt |    6 ++++++
>  include/linux/major.h     |    1 +
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 05c8064..d18070b 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -3142,6 +3142,12 @@ Your cooperation is appreciated.
>  		  1 = /dev/blockrom1	Second ROM card's translation layer interface
>  		  ...
>  
> +260 char	OSD (Object-based-device) SCSI Device
> +		  0 = /dev/osd0		First OSD Device
> +		  1 = /dev/osd1		Second OSD Device
> +		  ...
> +		  255 = /dev/osd255	256th OSD Device
> +
>   ****	ADDITIONAL /dev DIRECTORY ENTRIES
>  
>  This section details additional entries that should or may exist in
> diff --git a/include/linux/major.h b/include/linux/major.h
> index 8824945..058ec15 100644
> --- a/include/linux/major.h
> +++ b/include/linux/major.h
> @@ -171,5 +171,6 @@
>  #define VIOTAPE_MAJOR		230
>  
>  #define BLOCK_EXT_MAJOR		259
> +#define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device */
>  
>  #endif

