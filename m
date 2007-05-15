Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbXEOXZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbXEOXZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbXEOXZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:25:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:52359 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbXEOXZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Yc4KxY/+ik7cAf4+ayC711huY1jc3jBSyZrk2KFc+d+DlqoAU4c13/OeUkpZj69ESvExkHztYKhiG8APLRV9HMv7Zi8rd4uLEw1wijGIEWBzUV4QDja6xGLT6QOvfBsjE26yUYn5I2QngnoLifHW5P5WAvEf22UEpjgssEIs8aE=
Message-ID: <464A4163.7090509@gmail.com>
Date: Wed, 16 May 2007 03:25:23 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [PATCH] em28xx and ivtv should depend on PCI
References: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk>
In-Reply-To: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/media/video/em28xx/Kconfig |    2 +-
>  drivers/media/video/ivtv/Kconfig   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
> index 3823b62..2c450bd 100644
> --- a/drivers/media/video/em28xx/Kconfig
> +++ b/drivers/media/video/em28xx/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_EM28XX
>  	tristate "Empia EM2800/2820/2840 USB video capture support"
> -	depends on VIDEO_V4L1 && I2C
> +	depends on VIDEO_V4L1 && I2C && PCI

Err .. why would a USB device need to be depend on PCI ?

