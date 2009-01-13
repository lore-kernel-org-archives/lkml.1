Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZAMNdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZAMNdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbZAMNdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:33:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:45853 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759642AbZAMNdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SNJwTeDMswKeoZs1fJ+7jbMzae0DDx9byghQxvAEupFtvfOCNGLIPEL97aSgIQoCDj
         3XYFSHUnjdbLkznSz2NUVtzlRy20a+uSVXcmtl+wysZOjb27f9+U9YG9A6htUCC/jatq
         3BK2iFPCIOCErz8IonMcytSyvTbpkC5nGO6Wk=
Message-ID: <b6a2187b0901130533m118e9401k8a7152d6f5982708@mail.gmail.com>
Date: Tue, 13 Jan 2009 21:33:23 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090113132805.GE30352@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090113081316.GA2292@elf.ucw.cz> <200901131239.21995.rjw@sisk.pl>
	 <200901131342.44562.borntraeger@de.ibm.com>
	 <20090113132805.GE30352@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 9:28 PM, Pavel Machek <pavel@suse.cz> wrote:
>> Am Dienstag 13 Januar 2009 schrieb Rafael J. Wysocki:
>> > On Tuesday 13 January 2009, Pavel Machek wrote:
>> > > Hi!
>> > >
>> > > Just when I thought long merge window means less problems...
>> > >
>> > > ...suspend seemed to work until last tuesday or so. Now it hanged two
>> > > times; once so hard that power button powercycle did not result in
>> > > booting machine. (thinkpad x60)
>> > >
>> > > I'll do some more tests...
>> >
>> > There are a couple of things you may want to revert, like
>> > 7503bfbae89eba07b46441a5d1594647f6b8ab7d and
>> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .
>> >
>> > Please let me know if that helped.
>>
>> I tested rc1+ these two reverts yesterday on my T61p. Doesnt work. There must
>> be at least one more patch that broke S2R on my thinkpad. In fact, it is cpu
>> hotplug that is broken (unplug works).
>
> I reproduced that: echo 0 > online works, echo 1 > online hangs. Will
> compile SMP-less kernel to verify that there are no more problems...
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I've a X61 running 32-bit and it's able to suspend-to-ram.

Please see "[Bug #12422] 2.6.28-git can't resume from str" if it's
fixes your problem. Try to pull Linus' latest tree first and you need
apply only Rafael's latest patch.

Thanks,
Jeff.
