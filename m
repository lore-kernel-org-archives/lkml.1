Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbXFFL0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbXFFL0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbXFFL0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:26:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59986 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbXFFL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:26:41 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 06 Jun 2007 13:26:24 +0200
References: <8siVc-46n-17@gated-at.bofh.it> <8sktY-6G7-13@gated-at.bofh.it> <8skDC-6Su-5@gated-at.bofh.it> <8sl6G-7uE-9@gated-at.bofh.it> <8slgk-7Gl-3@gated-at.bofh.it> <8slq0-89X-9@gated-at.bofh.it> <8snLc-3ik-29@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hvtej-0000eT-3V@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX197J+b8gOnO5PlSRyADSUbhxjFOjjkyHC6/QyD
 BitjHAQ5FG5TNI1RvGryai30VshTmmJMAgzr995R00w2RNO/Kh
 09hh09ZGroGJnyDUbu7XQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Mon, 04 Jun 2007, Dmitry Torokhov wrote:

>> >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
>> >often. Launch the line above and try to do some typing...
>> 
>> This used to work fine on my box last time I tried it (the switch
>> itself is offloaded to a keventd and shoud not get in the way) but
>> then they push all kind of ACPI/SMM crap together with KBC so who
>> knows... I should try it again when I get home.
> 
> Err... in laptops, almost *always* the KDC is emulated by the embedded
> controller, so I bet you're right on the money, there.  It is not "a buggy
> KDC", it is a buggy EC firmware and/or buggy SMBIOS which is a lot more
> common.

It happens on my desktop using an original IBM Model M PS/2 keyboard, too.

The keyboard controler is known to be too slow for 80286, you shouldn't be
surprised by that thing being too slow for modern PC, at least if you're
stroboscoping the LED.
-- 
knghtbrd:<JHM> AIX - the Unix from the universe where Spock has a beard.

Friﬂ, Spammer: GpQo.qz@7eggert.dyndns.org mjjrpVo@wbbvIdbS.7eggert.dyndns.org
 Fbb95rv3@7eggert.dyndns.org m@u.7eggert.dyndns.org o@ffkpN.7eggert.dyndns.org
