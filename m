Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124Ab0AJJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0AJJ2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 04:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516Ab0AJJ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 04:28:29 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52101 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0AJJ21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 04:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=URbcNij/a3kMFFOXebqzYv+iUj+x1qn9jZBh6I3mKpiOrf5eEPj/YbM8Q1+YC6D9WO
         WqeR9BFJKJgQrafn78BgoNl86ijqxUnH3k1cezx0CPD8G11rHo1kMSWpw6CUfKXtlhW3
         ZpMv4avo2WZfuUSSmZl8Qn1ZqxfIuj7tJW0RI=
MIME-Version: 1.0
Date: Sun, 10 Jan 2010 10:28:26 +0100
X-Google-Sender-Auth: 34b0c7d106da9292
Message-ID: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
Subject: "m68k: Cleanup linker scripts using new linker script macros." and 
	old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre has a new 
	email address)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Tim Abbott <tabbott@ksplice.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 05:56, Michael Schmitz
<schmitz@biophys.uni-duesseldorf.de> wrote:
>> > > I'll verify that on the new tree, and start bisecting. Sigh.
>> >
>> > Good luck!
>>
>> 7c5fd5619dc89fb52d2c2cf144fc6e4365427b86 is first bad commit
>> commit 7c5fd5619dc89fb52d2c2cf144fc6e4365427b86
>> Author: Tim Abbott <tabbott@ksplice.com>
>> Date:   Sun Sep 27 13:57:55 2009 -0400
>>
>>     m68k: Cleanup linker scripts using new linker script macros.
>>
>>     Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>>     Tested-by: Andreas Schwab <schwab@linux-m68k.org>
>>     Cc: Roman Zippel <zippel@linux-m68k.org>
>>     Cc: Sam Ravnborg <sam@ravnborg.org>
>>     Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>
>> :040000 040000 5bdbf7ce5dd4ea2f23669c6a6ec11192865b5bfa
>> d3b7397533b0af6261747ccef3cff9cd40f6baf9 M    arch
>
> Backing out that commit on the top of the tree results in a bootable
> 2.6.33-rc2 for me
>
> The order of symbols in the system map is different (as you would expect)
> but I don't see what implicit assumption would be violated.

Tim, any clues? Michael is using gcc 3.3.6 and binutils 2.16.
It works fine with my 4.1.2/2.18 vombo.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
