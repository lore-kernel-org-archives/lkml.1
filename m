Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYJVSkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYJVSkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYJVSjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:39:55 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:22025 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYJVSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BEFGSDSuH9I1jaClbRHL6KQXOo0HvgQnqD2J34OZLMDwwumkPXJ9Ke26EkKYlrrKTn
         zpyS7h9cq1JHtrmwhUpiIwRTS0sJU1QdrVxSpFvJ4jsfrggt8nRQHj618TsrZ/LnuQmY
         pwCSiYoZsVwj015wULfXpvvXr1LZiRa7JIK60=
Message-ID: <d9def9db0810221139w12ba033g360292d9624a1f91@mail.gmail.com>
Date: Wed, 22 Oct 2008 20:39:51 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alex Riesen" <raa.lkml@gmail.com>
Subject: Re: [PATCH] em28xx patches against the latest git tree
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de,
       "Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <20081022182924.GA4626@blimp.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com>
	 <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
	 <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com>
	 <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com>
	 <20081022182924.GA4626@blimp.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 8:29 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> Markus Rechberger, Wed, Oct 22, 2008 20:10:49 +0200:
>> On Wed, Oct 22, 2008 at 7:59 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
>> > 2008/10/22 Markus Rechberger <mrechberger@gmail.com>:
>> >>> commit history is available at:
>> >> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
>> >>
>> >
>> > There is already an Empia EM28XX driver in the official tree. If your driver
>> > is based on it, could you point at the first commit in *your* tree at
>> > mcentral.de which
>> > corresponds to that driver? (if you do, your history can be moved into
>> > central Git
>> > repo completely, every commit of it)
>> >
>>
>> The development has been split off for 3 years from the original
>> repository. The internal driver differs alot.
>
> So it is more like a new driver. I tried merging them about half a
> year ago (unsuccessfully, of course). In the end your driver worked
> with that piece of hardware I have (it seem to produce an awful lot of
> tracing though) and I stayed with it.
>
>> The driver has a long and rather bad history, which I'd like to avoid
>> by using the different directory.
>
> You could submit patches depricating it. Does the old driver support
> something yours does not?
>

There are some devices with a knob available that reading that
register is currently
not implemented in the newer driver, netBSD people figured out that
interrupts are delivered
when a key gets pressed (even on the remote control). This is a
construction side at the moment
and it should be changed to something appropriate like the netBSD
people implemented.

>> Some patches got ported from my repository into the kernel although
>> most devices don't work at all with the current inkernel driver (eg.
>> em2888, flash based, isdb-t, cx25843, some saa7114.. based devices).
>
> Mine (a Pinnacle-Apple-something, USB) does not work with it at all.
>
>

There's one limitation I cut out the drx3975d (might re-add it within
the next week
to the git repository)
I know this one is required for the Pinnacle 330e and an Hauppauge based device.

If you have problems with your device please start a thread on the em28xx ML:
http://mcentral.de/pipermail/em28xx/

regards,
Markus
