Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbXHFS0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbXHFS0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbXHFS0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:26:43 -0400
Received: from neon.samage.net ([85.17.153.66]:52020 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbXHFS0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:26:41 -0400
Message-ID: <50209.81.207.0.53.1186424795.squirrel@secure.samage.net>
In-Reply-To: <46B75E8E.1040305@gmail.com>
References: <p73abtbpk2s.fsf@bingen.suse.de> <46B06815.10200@gmail.com>
    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
    <46B0818F.10204@gmail.com>
    <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
    <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>
    <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
    <20070801150939.GA24710@elte.hu>
    <52091.81.207.0.53.1185982005.squirrel@secure.samage.net>
    <20070806071200.GC5359@elte.hu> <46B71DBF.7000000@gmail.com>
    <46944.81.207.0.53.1186413575.squirrel@secure.samage.net>
    <46B75E8E.1040305@gmail.com>
Date: Mon, 6 Aug 2007 20:26:35 +0200 (CEST)
Subject: OT: enabling Xcomposite [was: Linux Kernel cfs scheduler and xorg 
     kbd]
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
X-Scan-Signature: 76f3589a93270604ea078d468a2051b3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 6, 2007 19:46, Rene Herman wrote:
> On 08/06/2007 05:19 PM, Indan Zupancic wrote:
>
> [ Yes, OT, I'll shelve it after this ]

Me too, and I wonder if we should've dropped a bunch of CCs...

>
>> Anyway, if you want to experience a shock, try enabling xcomposite and
>> run xcompmgr -a or something. It's so wonderfully smooth (even though
>> some rendering seems slower than before, it's really worth it for me).
>
> Don't believe I can -- using a Matrox Millenium G550 (driver mga) and
> nothing I do seems to have an effect.

Well, as far as I know adding the following to your xorg.conf should be enough:

Section "Extensions"
        Option  "Composite"     "enable"
EndSection

and then to enable it at runtime start a composite manager.

Reading the mga manpage it seems you need to add

Option "AccelMethod" "EXA"

to the driver section. (Though it says EXA is possibly unstable.)

Run "xdpyinfo | grep Composite" to see if it works or not.

But as you said, getting off-topic, so if the above doesn't work sent a
private mail, or go to the xorg mailinglist.

Greetings,

Indan


