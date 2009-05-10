Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZEJXrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZEJXrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZEJXrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:47:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45233 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZEJXrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
References: <20090509143742.GA27663@kroah.com> <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com> 
	<20090509150853.GA32394@suse.de> <20090509082233.32cbb8e4@infradead.org> 
	<20090509161923.GA942@suse.de> <20090509223454.4642753d.akpm@linux-foundation.org> 
	<20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop> 
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 01:47:16 +0200
Message-ID: <ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 23:19, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> /me boggles, however does one end up with that many partitions on so few
>> disks?
>
> It happens. Tejun did the extending because libata users were really
> hitting these limits.
>
>> /boot
>> /
>> /home
>> /usr
>> swap
>> /usr/local
>> /opt
>>
>> and I'm seriously out of sensible ideas.
>
> I've seen two usual variants
>
>        Fedora & Unbuntu & Debian & ....
>
>        Fedora 10 & Rawhide & Fedora 9 & ...
>
> for people who like to play with distros or need to test a product on them
>
> and once you do that 16 is quite easy

That's right. Also people with virtualization, running many guest from
individual partitions, like to do that - and 16 is nothing for them.
:)

Some of us run the dynamic sd minors already, and it's not unlikely we
will enable it pretty soon for the distro.

Thanks,
Kay
