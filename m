Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZLFTtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZLFTtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZLFTtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:49:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65413 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZLFTtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=KH3T+E4psWpkFS9W3xHCdx8Rx6gUxYcsoDZkJIjLefQL/mKf/tf9Kb8AIeE2XBqCGF
         NefBrhjAMDKCSoL3RqVZKzQG7taDnMl0UxUXzcvyY7HbrRlY9CBONU5Fcya7JtUAMouj
         pYhaU2tlrEPZp120ZuIazGjbza7GX5fluYJfQ=
MIME-Version: 1.0
Date: Sun, 6 Dec 2009 20:49:25 +0100
X-Google-Sender-Auth: 6b0b8fd4eeba6931
Message-ID: <10f740e80912061149w277105e2l31e9fef13221fee1@mail.gmail.com>
Subject: headers_check: asm-*/hw_breakpoint.h is not exported
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`make headers_check' now complains:

usr/include/linux/perf_event.h:22: included file
'asm-m68k/hw_breakpoint.h' is not exported

although CONFIG_HAVE_HW_BREAKPOINT is not set.

As <asm/hw_breakpoint.h> exists for x86 only, I guess every one else
is suffering from this.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
