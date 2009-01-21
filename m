Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZAUUBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZAUUBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZAUUA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:00:59 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:42864 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZAUUA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cWYG9tLjFgpldotDiaKYDMgBxOiapzad25K1BT3XFnaunVhQTmGqGdFVJ3kM3a5PIh
         6tYcSeoctFjx8P6YPgyECYPFwgNXZ5Rk5TlsdGDVrs/K9/pt1b7xZV8jz+1fybvlqYCf
         f4v8N8Yf9xzFnoggWBYsosNcWAPJqaqsCf0vc=
MIME-Version: 1.0
In-Reply-To: <20090121171423.GI21473@genesis.frugalware.org>
References: <20090121171423.GI21473@genesis.frugalware.org>
Date: Wed, 21 Jan 2009 12:00:57 -0800
X-Google-Sender-Auth: 8f5e085fbed1fc32
Message-ID: <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
From: john stultz <johnstul@us.ibm.com>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?ISO-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 9:14 AM, Miklos Vajna <vmiklos@frugalware.org> wrote:
> We just recently upgraded from Linux 2.6.27 to 2.6.28.1 and we noticed
> that on some i686 machines the system clocks runs way faster than
> necessary, they count about 70 minutes in an hour.
>
> The strange fact is that using the same config on some other i686
> machines the problem is not reproducible.
>
> We had no messages on boot using the quiet option with 2.6.27, now there
> is a
>
>        IO APIC resources could be not be allocated.
>
> with 2.6.28. I'm not sure if this is related or not.
>
> I'm attaching the dmesg of my laptop (where the bug is reproducible),
> the config and the lspci output.

Could you send the output from:
   cat /sys/devices/system/clocksource/clocksource0/current_clocksource
   cat /sys/devices/system/clocksource/clocksource0/available_clocksource

For both kernels on the affected hardware ?

Also could you attach the dmesg for 2.6.27 on the same hardware?
