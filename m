Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYGKK04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYGKK04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYGKK0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:26:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:32234 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYGKK0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M3sKSuDzTPc9MkSNHBxqikf2M3eKJqIKD8dRtbxyuN6b88+0C/CDV3DEkbGP0Jl+6s
         9TCfSxFtKUoKaZr5aYR1k4JbFf64exiAOTxlu6aMzmJnLrZYTieO2BGh9+yP8s7nhDGt
         9bECnKesCiw0P9llUNerSkiY2TruEIamaKkOo=
Message-ID: <aec7e5c30807110326s4b5cbad6j83ca0fe9db299f9@mail.gmail.com>
Date: Fri, 11 Jul 2008 19:26:47 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V3
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080711101839.GA26106@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080711095527.6762.84233.sendpatchset@rx1.opensource.se>
	 <20080711101839.GA26106@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 7:18 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> Magnus Damm wrote:
>>   - kept irq control spinlock to serialize user space access
> I think you want to assert, that after a succeeded
>
>        echo 0 > /dev/uioX
>
> the userspace doesn't need to check for a pending irq?!  What happens if
> the irq triggers before you take the lock?

No, I'm not trying to solve anything like that. =)

The serialization code is only there to correctly handle multiple
processes/threads.

/ magnus
