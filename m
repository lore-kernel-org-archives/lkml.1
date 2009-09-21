Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZIUDGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZIUDGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 23:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZIUDGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 23:06:12 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:53063 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbZIUDGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 23:06:12 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2009 23:06:12 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qQmYTrNX92f0C2fvqzmqDUpZNCRa9TXZg7bBC62djbUFoCGJwn9DNMP20XH7lmNuX5
         GlU9xPTsl2YEz0wLsAb8Z4LYRcb7taU7SSSzA3u+F5xBnoMMBNbTaNurwXQpWZat7KLV
         rEDgA+ClP80LQYWrdG9O4dv3OJ2vrfhCdMHvI=
MIME-Version: 1.0
In-Reply-To: <20090920150842.GF11621@kroah.com>
References: <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
	 <1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com>
	 <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>
	 <20090918150541.GB9307@kroah.com>
	 <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com>
	 <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
	 <20090918195005.GA11726@elte.hu>
	 <21d7e9970909191843l6fbb835bme509c18cedfd728c@mail.gmail.com>
	 <20090920150842.GF11621@kroah.com>
Date: Mon, 21 Sep 2009 12:58:16 +1000
Message-ID: <21d7e9970909201958k5318c319tbc4a664526530271@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was: 
	Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster)
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 1:08 AM, Greg KH <greg@kroah.com> wrote:
> On Sun, Sep 20, 2009 at 11:43:33AM +1000, Dave Airlie wrote:
>> >
>> > Self-contained /dev is great, udev is a total PITA on older distros (on
>> > this box it sometimes takes 3 minutes for udev to boot ...) so turning
>> > on devtmpfs and getting something functional in exchange is a big
>> > selling point IMO.
>>
>> udev taking 3 minutes usually means you have a kernel driver bug,
>> udev doesn't have a sleep for 3 minutes, it loads drivers and usually
>> waits for them to finish. Since someone decided to merge a stupid
>> floppy PNP match I've seen a lot of floppyless machines hit a 30sec
>> udev delay. so many that we disabled the pnp floppy on Fedora.
>
> Woah, I've run into this problem as well.  Where is this PNP floppy
> match so I can disable it?
>
http://cvs.fedoraproject.org/viewvc/rpms/kernel/F-12/die-floppy-die.patch?revision=1.1&view=markup

is what we are shipping currently, see if it helps.

Dave.
