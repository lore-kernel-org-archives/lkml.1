Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYJ3HYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYJ3HYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYJ3HX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:23:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbYJ3HX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:23:57 -0400
Date: Thu, 30 Oct 2008 00:23:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-input@ver.kernel.org
Subject: Re: [PATCH] Fix hid_device_id for cross compiling
Message-Id: <20081030002332.4ef1fac4.akpm@linux-foundation.org>
In-Reply-To: <jevdvgl345.fsf@sykes.suse.de>
References: <jevdvgl345.fsf@sykes.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 00:30:18 +0200 Andreas Schwab <schwab@suse.de> wrote:

> struct hid_device_id contains hidden padding which is bad for cross
> compiling.  Make the padding explicit and consistent across
> architectures.
> 

What is "bad" about it?  Can you expand a bit on the problem which is
being fixed here?  Before-and-after user-visible behaviour?

Thanks.

> ---
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index eb71b45..0e4f303 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -135,6 +135,7 @@ struct usb_device_id {
>  
>  struct hid_device_id {
>  	__u16 bus;
> +	__u16 pad1;
>  	__u32 vendor;
>  	__u32 product;
>  	kernel_ulong_t driver_data

