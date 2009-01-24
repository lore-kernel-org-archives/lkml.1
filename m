Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZAXJJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZAXJJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 04:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZAXJJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 04:09:09 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37674 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZAXJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 04:09:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HJbxKoBTcd1yialxsxVX+h9fCJcK60zEvaDjzOy7jDyY527tPnm4j5MzOEgm7eoLov
         PJ2II+z8siz6lzuSwLWh6FFQuPHBQ+vfneD8nApiCk6jZGXNZTVPCGmUnur/KpHzNpv/
         OlNsdLtgHGBCMf3gl7b3OKg22syx5XcjIY1VI=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0901240951110.13803@anakin>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <Pine.LNX.4.64.0901240951110.13803@anakin>
Date: Sat, 24 Jan 2009 11:09:05 +0200
Message-ID: <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: adaplas@pol.net, linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/24 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Fri, 23 Jan 2009, Risto Suominen wrote:
>> Xserver Xfbdev (kdrive) uses linux framebuffer in graphics mode. It doesn't
>> need the text mode cursor, it's a bit annoying to have it there sitting in a
>> corner. This patch disables the cursor even when in graphics mode.
>>
>> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
>> ---
>> The testing is done on kernel version 2.6.18.
>
> Which is well... quite old.
>
> Does it also (still) happen with 2.6.28?
>
Well, I don't really know, but I assume it will: fbcon_is_inactive()
still returns true if vc->vc_mode != KD_TEXT, and thus hinders
fbcon_cursor() from doing anything in graphics mode.

Risto
