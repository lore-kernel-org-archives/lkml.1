Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbZCLWkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbZCLWkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZCLWkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:40:09 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:48514 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZCLWkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kyHE8EZzuKPRlKmMhhWPqWDG1UP8ieHKI69gNYripQPjX3WhYGpMGxf6sOz+ZRz+sv
         iwLf/s6CqTXtL7IYZofDsmPdV/zkbCsEAqKeAJFepaEHBOmm93m/zQBACovsqRR8GcS3
         IztghbcLG5qMRj0ziKsWkK0+j06F4esNHfODY=
MIME-Version: 1.0
In-Reply-To: <20090312210216.GB14205@uranus.ravnborg.org>
References: <200903120437.03837.rob@landley.net>
	 <20090312095854.GA9398@uranus.ravnborg.org>
	 <200903121503.37195.rob@landley.net>
	 <20090312210216.GB14205@uranus.ravnborg.org>
Date: Thu, 12 Mar 2009 23:40:02 +0100
X-Google-Sender-Auth: 352124e0d23547fe
Message-ID: <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>,
       Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 22:02, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> And, yes, I can confirm the m68k include/asm/unistd.h from linux-next actually
>> has contents, thanks to commit 646652bded41f4c3bd375b4e03a25b42da93f40b
>>
>> Anyway, here's hoping the fix makes it into 2.6.29.
>
> Why not telling the m68k maintainer that you think it should go into 2.6.29?
>
> As it stand now we will ikely see another mail from you "I already said so"
> when we ship it broken but you did not care to tell relevant people.
>
> grep -C 5 -i m68k MAINTAINES revelas this:
> M68K ARCHITECTURE
> P:      Geert Uytterhoeven
> M:      geert@linux-m68k.org
> P:      Roman Zippel
> M:      zippel@linux-m68k.org
> L:      linux-m68k@lists.linux-m68k.org
> W:      http://www.linux-m68k.org/
> W:      http://linux-m68k-cvs.ubb.ca/
> S:      Maintained
>
>
>        Sam
>

There are a few more:

param.h:#include "param_no.h"
param.h:#include "param_mm.h"
ptrace.h:#include "ptrace_no.h"
ptrace.h:#include "ptrace_mm.h"
setup.h:#include "setup_no.h"
setup.h:#include "setup_mm.h"
sigcontext.h:#include "sigcontext_no.h"
sigcontext.h:#include "sigcontext_mm.h"
siginfo.h:#include "siginfo_no.h"
siginfo.h:#include "siginfo_mm.h"
signal.h:#include "signal_no.h"
signal.h:#include "signal_mm.h"
swab.h:#include "swab_no.h"
swab.h:#include "swab_mm.h"

Rob, do these also causes problems?
Some (not all) of them are fixed in linux-next.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
