Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZIJAkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZIJAkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZIJAkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:40:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:40867 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZIJAkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=cO7Xh/hGhw0oB3HnkW8u3jn9udop2kG3zNaazpr65VOpPvE7uwsgHcMfZeO88Qxqey
         T8yQSPWT/wMOIRZcAXHU2jzGkcBfDK1b8gqRTac0kX9BFvmQSorCvcVIwRIj+VJsbpjY
         YpKAMtkvjUxUyi5lKIVT/Qi9d/r1TtAo/iZZE=
MIME-Version: 1.0
In-Reply-To: <1252507740.14793.115.camel@desktop>
References: <20090909075024.GA1400@ucw.cz> <1252507740.14793.115.camel@desktop>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 10 Sep 2009 08:40:24 +0800
Message-ID: <f17812d70909091740m3ef98e44t18dffc6a2c7c1126@mail.gmail.com>
Subject: Re: [patch for 2.6.31] zaurus c3000 aka spitz: fix resume
To: Daniel Walker <dwalker@fifo99.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 10:49 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Wed, 2009-09-09 at 09:50 +0200, Pavel Machek wrote:
>> Hi, Linus!
>>
>> Spitz resume was broken for year or likely two, and it would be very
>> nice to fix it for 2.6.31 release. One liner is below, and it really
>> can not harm. It already is in Eric's fix queue, so pulling that for
>> .31 should work, too.
>>
>> Do you think you could take it?
>
> One checkpatch error here..
>
> ERROR: trailing whitespace
> #77: FILE: arch/arm/mach-pxa/sharpsl_pm.c:681:
> +^Iif ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || $
>
> total: 1 errors, 0 warnings, 10 lines checked
>

This has been fixed in the version I sent to Russell.
