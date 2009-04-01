Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbZDAUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbZDAUXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbZDAUXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:23:11 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51621 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188AbZDAUXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iphVIS1h871tZpVbJUsqJnIW6cxzTD8ZMeSgmAKbXJMBm9dbmIsvJHnOj4bZTBH8sS
         iIVnEzYNADpEidVDV0d54l+7ScrQ235bw9C+KZpMG4N73aJMCTwbE08grDztNPnO1m0P
         8aAFzJBOvEw40vAixOBQE4FW5Rsw2KKWt9HFk=
MIME-Version: 1.0
In-Reply-To: <20090401194810.GY3795@csclub.uwaterloo.ca>
References: <200903120437.03837.rob@landley.net>
	 <20090401165741.GA3797@csclub.uwaterloo.ca>
	 <20090401190340.GA29673@uranus.ravnborg.org>
	 <20090401194810.GY3795@csclub.uwaterloo.ca>
Date: Wed, 1 Apr 2009 22:23:06 +0200
X-Google-Sender-Auth: 4c652b45a617618d
Message-ID: <10f740e80904011323t219063b0ife4db1677ca0d22b@mail.gmail.com>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 21:48, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> On Wed, Apr 01, 2009 at 09:03:40PM +0200, Sam Ravnborg wrote:
>> They decided to fix it by eliminating the *_{no,mm}.h files for exported headers.
>> The patch is already in mainline.
>
> Oh good.  Yay!  Just didn't make it into 2.6.29 I suspect.  Well there
> is always 2.6.30.

It entered mainline just before v2.6.29 (after v2.6.29-rc8)?
Or did you find a new problem?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
