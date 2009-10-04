Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZJDId2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZJDId2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 04:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZJDId2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 04:33:28 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:42118 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZJDId0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 04:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rlTohUr6fHzxhnNcHyl4V6CfzToOEscKt6LnqxE/hirUFbpcMig8fCsrU19GMovCIp
         AfRDwUZd3twa9KOIysHAKQWs7HK6Fbbs0dO4k3Hd6kAWEOuEsJYb5HBYOxOwR1z2+DqQ
         hgNn8Fhl06o2tiDQgXbhs2Mb16pRHdMHa7W8s=
MIME-Version: 1.0
In-Reply-To: <20090930065326.GA13850@merkur.ravnborg.org>
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com>
	 <1253119466-19488-3-git-send-email-tabbott@ksplice.com>
	 <10f740e80909270258o6bde0f3dk720bd5b5c091ed2f@mail.gmail.com>
	 <m2ocowwngg.fsf@igel.home>
	 <alpine.DEB.1.10.0909271351110.14151@dr-wily.mit.edu>
	 <m3zl8dbron.fsf@hase.home>
	 <20090930065326.GA13850@merkur.ravnborg.org>
Date: Sun, 4 Oct 2009 10:32:48 +0200
X-Google-Sender-Auth: 6a870580adfaf5f4
Message-ID: <10f740e80910040132l2d5e212ch876bfee9142ab81b@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] m68k: Cleanup linker scripts using new linker 
	script macros.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andreas Schwab <schwab@redhat.com>, Tim Abbott <tabbott@ksplice.com>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 08:53, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, Sep 29, 2009 at 07:12:56PM +0200, Andreas Schwab wrote:
>> Tim Abbott <tabbott@ksplice.com> writes:
>>
>> > Below is a new version of the second patch that attempts to address this
>> > by putting the ALIGN inside a section, so that _end is at the end of the
>> > load segment (I also did a bit more cleanup):
>> >
>> >   .init_end : {
>> >     /* This ALIGN be in a section so that _end is at the end of the
>> >        load segment. */
>> >     . = ALIGN(PAGE_SIZE);
>> >     __init_end = .;
>> >   }
>> >
>> >   _end = .;
>>
>> This works fine.
>
> Thanks for testing Andreas.
>
> Geert - I assume you take the corrected version and push to Linus?

I will (eventually), but it probably won't make it for -rc2. Same for
the other m68k patches I have still lying around.
I hope to have more m68k development time in a month or so...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
