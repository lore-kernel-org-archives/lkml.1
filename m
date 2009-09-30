Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZI3MJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZI3MJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZI3MJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:09:22 -0400
Received: from mail-yw0-f199.google.com ([209.85.211.199]:60061 "EHLO
	mail-yw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZI3MJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xilmqqco0pZ1/8e+9u1War0fWePksJBALVBPqOsWRc6Ui9ee3FN4H4d50062Poo/2L
         gpXPUQuaSwRxgCTxdJiXJFOZIXoJCXuKtVRn9G8mNFjcLX9KTC+YgNcts8f/pEHOgt4c
         urIkZF13Q9Eydyo9p5CMzinHZtlIC0vayA6mo=
MIME-Version: 1.0
In-Reply-To: <20090930120655.GG1412@ucw.cz>
References: <20090930120655.GG1412@ucw.cz>
Date: Wed, 30 Sep 2009 16:09:25 +0400
Message-ID: <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com>
Subject: Re: 2.6.32-rc1: spitz boots but suspend/resume is broken
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 4:06 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> matrix keyboard driver needs to be enabled, otherwise it seems ok.
>
> Unfortunately, it does not respond to power button in any visible way
> :-(. Any ideas what might be wrong/how to debug it?

Enable gpio-keyboard driver, verify (or port power button to it :))
and check that
enable_wakeup is enabled.

BTW: on tosa initially i had a problem w/ wakeup. The power button wasn't
able to wake the device up. However there was another gpio that was OR of
 power button and AC-in gpios that had to be used for wakeup. Please check
if the same design applies to your device.

>                                                                Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
With best wishes
Dmitry
