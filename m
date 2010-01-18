Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349Ab0AROob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0AROob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297Ab0AROoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:44:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:25666 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0AROo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=tM22Y9cnWkDqKjhOgAUE+UF1+ShenRvVAORGJmf3UvomTdoAitXtj40neFMlZpS3vz
         N1PS4Gv94+kEMt2eGiaVaNUJ+KmtCKRK+61LNAMP5V5uyX9ydwvmF2ma73bZusMcYoya
         imtEP5fz8mn0gkIcd9uFNcxzGNOOPOEpJHl30=
MIME-Version: 1.0
Date: Mon, 18 Jan 2010 15:44:27 +0100
X-Google-Sender-Auth: 4c94b2643838e4b3
Message-ID: <10f740e81001180644yd44121cv6dd963349563a290@mail.gmail.com>
Subject: linux-next build failure (was: Re: [PATCH/REPOST] pci: push 
	deprecated pci_find_device() function to last user)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       Greg KH <gregkh@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 19:08, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Thu, 14 Jan 2010 23:18:41 +0100 (CET)
> Tilman Schmidt <tilman@imap.cc> wrote:
>
>> Am 14.01.2010 17:28 schrieb Jesse Barnes:
>> > I can take it, but I lost the original patch.  Tilman, can you
>> > resend?
>>
>> Sure, here you are:
>>
>> Subject: [PATCH] pci: push deprecated pci_find_device() function to
>> last user
>>
>> The ISDN4Linux HiSax driver family contains the last remaining users
>> of the deprecated pci_find_device() function. This patch creates a
>> private copy of that function in HiSax, and removes the now unused
>> global function together with its controlling configuration option,
>> CONFIG_PCI_LEGACY.
>>
>> Impact: code reorganization, no functional change
>> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
>> ---
>> Note: This patch is not, nor does it intend to be, checkpatch.pl
>> clean. The issues checkpatch.pl reports on it were already present
>> before, and are unrelated to the topic of this patch.
>
> Applied to my linux-next branch, thanks Tilman.

Just guessing: something's wrong if CONFIG_PCI is not set?

http://kisskb.ellerman.id.au/kisskb/buildresult/2042085/

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
