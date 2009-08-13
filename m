Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZHMPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZHMPAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZHMPAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:00:43 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:48159 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZHMPAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mg2LUh4D4uqdXPTLU/Xbo618eRTbejBswt2Zw/IX/WL4u+d8g370qiCb87+9uQhLsf
         PFVmkQgGBO570hpn1itnqclZeoht52bMmT5nkI92wVP1sq/ACAvGb20k4W5guuURr6DV
         8amU4SIjz68k90dMqMC+8i8rqWuiizt0Z0jGc=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <200908131654.45227.rjw@sisk.pl>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
	 <11fae7c70908130244k3f20954ewa23c5a57fbd60410@mail.gmail.com>
	 <11fae7c70908130340w37782c04m861d2f429d639a9e@mail.gmail.com>
	 <200908131654.45227.rjw@sisk.pl>
Date: Thu, 13 Aug 2009 18:00:42 +0300
X-Google-Sender-Auth: c8b5ddfc61614460
Message-ID: <11fae7c70908130800q7b4a5293t5c373613d736d74@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 5:54 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Thursday 13 August 2009, Martin-Éric Racine wrote:
>> 2009/8/13 Martin-Éric Racine <q-funk@iki.fi>:
>> > On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> >> * Martin-Éric Racine <q-funk@iki.fi> wrote:
>> >>> Yes, this bug is still valid.
>> >>>
>> >>> Ubuntu kernel team member Leann Ogasawara and I are slowly
>> >>> bisecting our way through the changes that took place since 2.6.30
>> >>> to find the commit that introduced this regression. Please stay
>> >>> tuned.
>> >>
>> >> hm, the only outright Geode related commit was:
>> >>
>> >>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
>> >>
>> >> the jpg at:
>> >>
>> >>  http://launchpadlibrarian.net/28892781/00002.jpg
>> >>
>> >> is very out of focus - but what i could decypher suggests a
>> >> pagefault crash in the VFS code, in generic_delete_inode().
>>
>> This one might be a bit better:
>>
>> http://launchpadlibrarian.net/30267494/2.6.31-5.24.jpg
>>
>> >> Which could be a VFS bug, or a filesystem bug, or some unrelated
>> >> memory corruption hitting the inode data structure.
>> >
>> > It could indeed be many things.
>> >
>> > I've been trying to boot this into a larger framebuffer to be able to
>> > fit more data into my snapshots, but it appears that vga=795 doesn't
>> > work anymore. Have we reverted to Hex values again or is this just an
>> > issue of some kernel module missing from initrd?
>>
>> Never mind. Seems that vesafb was blacklisted. Works now. See the
>> image above. :)
>
> OK, so I guess the bug should be closed?

No, it cannot.  Please read the above more carefully.

Martin-Éric
