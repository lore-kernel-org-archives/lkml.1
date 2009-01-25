Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbZAYNEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbZAYNEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZAYND6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:03:58 -0500
Received: from mail-ew0-f10.google.com ([209.85.219.10]:33601 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZAYND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:03:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=unagerOOy+zyw+UmUbdT9cNxWaVaqxYuhQHCjEg0dDJ0Pt6TiV7J6n0u3as0zSdlOW
         kbAzBgZyLN6Iyt3FO8L9J1L/0AXLPonNImxRf7x3jvnr4OBXwnNjYG1Y6FW2mLesXw5d
         v62ceyyjbVf00w/yS7MD7zFICjlQMe+VqulnQ=
Message-ID: <497C6339.4040804@gmail.com>
Date: Sun, 25 Jan 2009 14:03:53 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org, anssi.hannula@gmail.com, gregkh@suse.de,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 09/10] HID: add compat support
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-7-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-8-git-send-email-jirislaby@gmail.com>	 <1210931362-18422-9-git-send-email-jirislaby@gmail.com> <3f9a31f40901232155q7f898f00l9a1cf16ca6c8fb75@mail.gmail.com>
In-Reply-To: <3f9a31f40901232155q7f898f00l9a1cf16ca6c8fb75@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> If you have any objections, then let me know, now it will look like this:

No objections from me, nice catch, thanks.

>  #endif /* HID_FF */
> 
> +#ifdef __KERNEL__
>  #ifdef CONFIG_HID_COMPAT
>  #define HID_COMPAT_LOAD_DRIVER(name)   \
>  /* prototype to avoid sparse warning */        \
> @@ -804,6 +805,7 @@ EXPORT_SYMBOL(hid_compat_##name)
>         extern void hid_compat_##name(void);    \
>         hid_compat_##name();                    \
>  } while (0)
> +#endif /* __KERNEL__ */
> 
>  #endif

