Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0CDRzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:55:46 -0500
Received: from mail.perches.com ([173.55.12.10]:1383 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab0CDRzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:55:45 -0500
Subject: Re: [PATCH 1/1] Stage: hv: Corrected all header comments to follow
 kernel-doc format
From: Joe Perches <joe@perches.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hashir Abdi <habdi@microsoft.com>, Greg KH <greg@kroah.com>
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56217DBFDF9@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <8AFC7968D54FB448A30D8F38F259C56217DBFDF9@TK5EX14MBXC116.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 09:55:43 -0800
Message-ID: <1267725343.12993.20.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 17:48 +0000, Hank Janssen wrote:
> From: Hank Janssen <hjanssen@microsoft.com>
> 
> Removed kerneldoc /** from functions that should not have them.
> Added proper kerneldoc headers to functions that should have them.
> diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c index d46eb14..1fc2710 100644
> --- a/drivers/staging/hv/Channel.c
> +++ b/drivers/staging/hv/Channel.c
> @@ -64,8 +64,9 @@ static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)  }  #endif
> 
> -/**
> - * VmbusChannelSetEvent - Trigger an event notification on the specified channel.
> +/*
> + * VmbusChannelSetEvent - Trigger an event notification on the
> +specified
> + * channel.
>   */
>  static void VmbusChannelSetEvent(struct vmbus_channel *Channel)  { @@ -119,7 +120,7 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)  }
> 
>  #endif

Yuck.

I don't know what you used for comment wrapping,
but it's broken here and in a bunch of other places.

Some are shown below:

[]

> -/**
> - * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer packets using a GPADL Direct packet type.
> +/*
> + * VmbusChannelSendPacketPageBuffer - Send a range of single-page
> +buffer
> + * packets using a GPADL Direct packet type.
>   */
>  int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
>                                      struct hv_page_buffer PageBuffers[], @@ -773,8 +777,9 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
>         return ret;
>  }
> 
> -/**
> - * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer packet using a GPADL Direct packet type.
> +/*
> + * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer
> +packet
> + * using a GPADL Direct packet type.
>   */
>  int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
>                                 struct hv_multipage_buffer *MultiPageBuffer, @@ -842,7 +847,7 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
>         return ret;
>  }


