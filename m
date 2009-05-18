Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZERN3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZERN3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZERN3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:29:13 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:44155 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751208AbZERN3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:29:12 -0400
Message-ID: <688406.16641.qm@web32603.mail.mud.yahoo.com>
X-YMail-OSG: DEYrKrAVM1nFClHVcAisox1bLfABBkBlxalt9_ry8msNGmUtrri.Zmj5ycRL4YCf9YzZKYtygal183SHg4eyL0B5rSVVulOHnf7WGj4FCcuZRvIu1dIyUpzKIRUct2YE3EnpjMv7n810oc6j0xkMYRmZEjZ.Ot674eiJ6JU9CRUcHqLiGKzBnlErgJC65JJt1.izN14MiswTKORQ3Z5ybb90ySmSHm43GrP80KWKc5JNxU50BSbvkeTXH_uREa5WLNSRKruR5HPoHHvJZNjDgaPLlYKkOo_x0UVbVP2jZ5K_o8u1EM_CehwYjcD.Qo09iQoejN09u2OAJbAZuSyyfvk-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
Date: Mon, 18 May 2009 06:29:13 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
To: linux-kernel@vger.kernel.org
Cc: mpm@selenic.com, spam trap <spamtrap@knobisoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CC Maintainer.


----- Original Message ----
> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: linux-kernel@vger.kernel.org
> Sent: Monday, May 18, 2009 2:58:35 PM
> Subject: Rgeression: 2.6.30-rc6-git3 build error - ICE from drivers/char/random.c
> 
> Hi,
> 
> trying to build 2.6.30-rc6-git3 with RHEL4.3 userspace (gcc (GCC) 3.4.5 20051201 
> (Red Hat 3.4.5-2)):
> 
> 
>   CC      drivers/char/mem.o
>   CC      drivers/char/random.o
> drivers/char/random.c: In function `get_random_int':
> drivers/char/random.c:1672: error: unrecognizable insn:
> (insn 202 148 150 0 
> /scratch/build/linux-2.6.30-rc6-git3/arch/x86/include/asm/tsc.h:23 (set (reg:SI 
> 0 ax [91])
>         (subreg:SI (plus:DI (plus:DI (reg:DI 0 ax [88])
>                     (subreg:DI (reg:SI 6 bp) 0))
>                 (const_int -4 [0xfffffffffffffffc])) 0)) -1 (nil)
>     (nil))
> drivers/char/random.c:1672: internal compiler error: in extract_insn, at 
> recog.c:2083
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See for instructions.
> Preprocessed source stored into /tmp/ccvLBDQc.out file, please attach this to 
> your bugreport.
> make[2]: *** [drivers/char/random.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
> 
> did not happen with -rc3. Config attached.
> 
> Cheers
> Martin

