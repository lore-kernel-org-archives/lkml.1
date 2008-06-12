Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFLQVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFLQVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYFLQVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:21:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:22640 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYFLQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fdjfvrSrnyrjXcTq7OQUGxBCKS08aZwM+w+SMhnZ7UTjkqtOooIyIz1O9+XQ3uVVyX
         hlX7NBmb3X6DcdzMOBSYWDg0U68OdtKLcSuZdwU1EZWLobVb7iuQ7WAPwb5dUyxESYaJ
         b0iw+lfSqdiwJ2NmtUKKqqGQC4gVguXovOMUQ=
Message-ID: <dd18b0c30806120921h4b31c927hce36f0b4eeea0e6d@mail.gmail.com>
Date: Thu, 12 Jun 2008 16:21:29 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: 26-rc5+git hang on boot bluetooth hidd/hid_devices
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <1213273171.5499.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213015948.7018.48.camel@localhost>
	 <1213022913.17870.4.camel@violet.holtmann.net>
	 <1213029509.4521.29.camel@localhost>
	 <1213035594.17870.6.camel@violet.holtmann.net>
	 <1213040101.15360.7.camel@localhost>
	 <dd18b0c30806091354j2b5ffb9bp5ae06d9537882c7d@mail.gmail.com>
	 <1213273171.5499.1.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 12:19 PM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Mon, 2008-06-09 at 20:54 +0000, Justin Mattock wrote:
>> On Mon, Jun 9, 2008 at 7:35 PM, Soeren Sonnenburg <kernel@nn7.de>
>> wrote:
>> > On Mon, 2008-06-09 at 20:19 +0200, Marcel Holtmann wrote:
>> >> Hi Soeren,
>> >>
>> >> > > > updating to 2.6.26-rc5+git I recognize that debian sid
>> suddenly hangs on
>> >> > > > boot when bluetooth is activated. The last message I see is
> [...]
>> >> then please disable hid2hci and see if it still has a problem and report
>> >> this to the USB guys.
>> >
>> > Indeed when I disable the call to hid2hci it boots through. While
>> > booting I see another (unrelated?) oops (see below).
>> >
>> > When I after booting call hid2hci in a terminal it simply hangs.
> [...]
>> > Code: b5 83 7d d4 32 bf 32 00 00 00 ba d0 00 00 00 89 de 0f 4e 7d d4 89 f8 89 7d e4 e8 f7 71 94 c7 89 f9 c1 e9 02 89 c2 89 45 e8 89 d7 <f3> a5 8b 4d e4 83 e1 03 74 02 f3 a4 8b 45 e0 b9 a0 00 00 00 8b
>> > EIP: [<f883b115>] isight_firmware_load+0x105/0x240 [isight_firmware] SS:ESP 0068:f7191cfc
>> > ---[ end trace 8ea9a3ecb
>
>> Sounds like you might be having the same issue I was having with isight_firmware
>> here is the link to the patch: http://lkml.org/lkml/2008/6/6/407
>> check and make sure, from what I could tell they look similar.
>> regards;
>
> Yes indeed. For the record: Looks like git-current has the patch and
> voila the system doesn't hang on hid2hci any longer :)
>
> Soeren
>

Cool; Quick question I'm not sure what version of the macbook pro you
have, but with me the version before the santa rosa release(the one
with ATI chipset) anyways I'm noticing on a cold boot the
isight_firmware and uvcvideo are not binding for some reason or
another. are you seeing this as well? i.g. if I start the system and
the two haven't binded I usually rmmod the two and then modprobe, then
reboot and all goes good, but as soon as I shutdown the system and
start the system back up the two seem to not bind. maybe I'm missing
something
As the for the situation with you I'm glad to see you're up and running.
regards;
-- 
Justin P. Mattock
