Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYEYStv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYEYStv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYEYStn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:49:43 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59034 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbYEYStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:49:43 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>, Michael Buesch <mb@bu3sch.de>
Message-Id: <4A84E98F-1C0D-4194-AC63-5455CCD5DD35@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Alexandre Oliva <aoliva@redhat.com>
In-Reply-To: <orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:49:38 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211640377.540.14.camel@pmac.infradead.org> <20080524152214.GA12582@uranus.ravnborg.org> <1211642706.31212.85.camel@shinybook.infradead.org> <1211643245.31212.88.camel@shinybook.infradead.org> <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org> <1211707837.17151.14.camel@johannes.berg> <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org> <orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

>> in the early days we had something like three drivers using the
>> request_firmware() and it was understood between the authors what the
>> filename was meant for.
>
> You're contradicting yourself.  Is it a filename, or is it not?
> Earlier, you said it wasn't, it was just a name that userspace was
> supposed to map to a filename.  Now, you're saying it is a filename.

it is a filename with any directory components.

> Clearly (to me) your wish to prohibit '/'s in the firmware name has to
> do with an attempt to force a distiction, to make the firmware a
> filename rather than a pathname.  But, as you said yourself, the
> mapping from firmware name is supposed to be entirely handled in
> userland, therefore it doesn't even begin to make sense to distinguish
> between filenames and pathnames.  You'd have to make assumptions that
> (i) the firmware name names files (with built-in firmware, it
> doesn't), and, if it is about filenames, (ii) what the pathname
> separator character is.  Should '\\' be ruled out as well, because
> someone might want /lib/firmware to be in a FAT filesystem?

Actually the request_firmware() is Linux specific :)

> nWouldn't it be better to leave the resolution of firmware names to
> content *entirely* up to userland?  Say, if userland wants to
> implement something very similar to the key-to-data map in-kernel
> built-in firmware, this would work just fine, without any artificial
> constraints?

And again the grouping into subdirectories should have been fixed in  
userspace by reading the driver name. The kernel should not do this at  
all.

Regards

Marcel

