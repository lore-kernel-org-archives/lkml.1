Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZEELPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZEELPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZEELPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:15:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:19329 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZEELPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gYyHs7yzZ4CAjYcgIqC6Km6AAX2JLgi5aGfMETavgb0jbu4vy8BiXMjf5xvmPzBbSr
         EwH3npCjDPMgFKd/ev0mH9T+GrRFm4l+hQQz77EjS4LojLeFDHUAurFKYDQ28ZiuRuj8
         UvpEhw3iYwgc7yFwhNSTqARbTUdZEFcg39/ic=
MIME-Version: 1.0
In-Reply-To: <20090505.130225.42780711.wl@gnu.org>
References: <20090503.132958.227862405.wl@gnu.org>
	 <20090504.182628.216265620.wl@gnu.org>
	 <21d7e9970905050344x2a92f9c6l8569b68bff905370@mail.gmail.com>
	 <20090505.130225.42780711.wl@gnu.org>
Date: Tue, 5 May 2009 21:15:25 +1000
Message-ID: <21d7e9970905050415s19201731s4907824ec340e8ee@mail.gmail.com>
Subject: Re: some kernel issues
From: Dave Airlie <airlied@gmail.com>
To: Werner LEMBERG <wl@gnu.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 9:02 PM, Werner LEMBERG <wl@gnu.org> wrote:
> From: Dave Airlie <airlied@gmail.com>
> Subject: Re: some kernel issues
> Date: Tue, 5 May 2009 20:44:18 +1000
>
>>> With my 945GM intel graphics card, I don't get TTYs which I could
>>> switch to with Ctrl-Alt-Shift-F1, for example, after X has started.
>>> Only F7 to switch back to graphics mode works fine.  In particular,
>>> I don't see any boot messages at start-up.  This has worked fine
>>> with a previous kernel like 2.6.27.21.
>>
>> Make sure you haven't enabled kernel mode setting.
>>
>> CONFIG_DRM_I915_KMS
>
> Uuuuh, completely undocumented.  Thanks!  Will check soon.
>

Huh?

 Choose this option if you want kernel modesetting enabled by default,
 and you have a new enough userspace to support this. Running old
 userspaces with this enabled will cause pain.  Note that this causes
 the driver to bind to PCI devices, which precludes loading things
 like intelfb.

But as you don't have it, it doesn't seem like that is the issue

Dave.
