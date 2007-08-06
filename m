Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXHFPTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXHFPTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbXHFPTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:19:44 -0400
Received: from neon.samage.net ([85.17.153.66]:42540 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764390AbXHFPTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:19:42 -0400
Message-ID: <46944.81.207.0.53.1186413575.squirrel@secure.samage.net>
In-Reply-To: <46B71DBF.7000000@gmail.com>
References: <p73abtbpk2s.fsf@bingen.suse.de> <46B06815.10200@gmail.com>
    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
    <46B0818F.10204@gmail.com>
    <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
    <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>
    <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
    <20070801150939.GA24710@elte.hu>
    <52091.81.207.0.53.1185982005.squirrel@secure.samage.net>
    <20070806071200.GC5359@elte.hu> <46B71DBF.7000000@gmail.com>
Date: Mon, 6 Aug 2007 17:19:35 +0200 (CEST)
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: "Indan Zupancic" <indan@nul.nu>
To: "Rene Herman" <rene.herman@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, teresa@kvitka.net,
       "Andi Kleen" <andi@firstfloor.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "CK Mailinglist" <ck@vds.kolivas.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       dmitry.torokhov@gmail.com, dtor@mail.ru
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: a2d32f98be707cbcda8602d5fffa976a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 6, 2007 15:10, Rene Herman wrote:
> On 08/06/2007 09:12 AM, Ingo Molnar wrote:
>
>> * Indan Zupancic <indan@nul.nu> wrote:
>>
>>> All right, how would you debug it? Give us some insight in how to
>>> solve hard to trigger, happens at most only a few times a day,
>>> annoying input bug? I thought the mouse warping was fixed after 23-rc1
>>> and that input locking patch, but alas, the third day it happened
>>> again.
>>
>> i've got no idea how to debug such input bugs best, but, as a starting
>> point, i've Cc:-ed the current maintainer of the input subsystem :-)
>
> FWIW, I haven't experienced my "stuck delete" key anymore -- "since using
> CFS v19.1", but that might very well just be coincedence. If anyone
> wants/needs me to, I'll try to debug it, but for now I seem to be fine again.

No stuck keys and no warping mouse seen yet since last time (currently running
2.6.23-rc2), so both problems are, for all practical purposes, fixed.

> Now all I need to know is whether or not moving thunderbird's windows around
> is expected to leave such an enormous non-repainting visual trail on the
> screen...
>
> I believe I'm concluding that I'm not all together fond of the "new" modular
> X.org.

I don't think it's fair to blame Xorg for that, except if changing back to an older
version fixes it. If Thunderbird is anything comparable to Firefox, then it's most
likely the generic slowdown of that program that might have made it worse. If it's
Xorg then it's probably something driver/settings related I guess, best to ask on
their mailinglist for that.

Anyway, if you want to experience a shock, try enabling xcomposite and run
xcompmgr -a or something. It's so wonderfully smooth (even though some
rendering seems slower than before, it's really worth it for me).

Greetings,

Indan


