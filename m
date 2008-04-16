Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbYDPHz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbYDPHz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYDPHzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:55:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37796 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbYDPHzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:55:16 -0400
Date: Wed, 16 Apr 2008 09:55:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: ye janboe <janboe.ye@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]kbuild: add arm, mips and i386 macros
Message-ID: <20080416075546.GA31296@uranus.ravnborg.org>
References: <af3ea28a0804092038q59a5b907ndb3d9fa33a6be834@mail.gmail.com> <af3ea28a0804152010g5a234640o94f39bbecf0d4637@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3ea28a0804152010g5a234640o94f39bbecf0d4637@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 11:10:31AM +0800, ye janboe wrote:
> No one think this patch is needed?

I have not had time to neither look through it nor to apply it.

Later,

	Sam
> 
> 2008/4/10, ye janboe <janboe.ye@gmail.com>:
> > commit a80cc2fe14ce7e7a6de70b5927b9c0a6ee530805
> >  Author: janboe <janboe.ye@gmail.com>
> >  Date:   Thu Apr 10 11:18:03 2008 +0800
> >
> >     the commits 56a974fa2d595fe6ebe433c525b8232ead539b76 and
> >  ae4ac12323c0ff80528cac3269151d580e23f923
> >     involved additional macros but not available on cygwin.
> >  Signed-off-by: Janboe Ye <janboe.ye@gmail.com>
> >  diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
> >  index 09f58e3..f864ab8 100644
> >  --- a/scripts/mod/modpost.h
> >  +++ b/scripts/mod/modpost.h
> >  @@ -42,6 +42,16 @@
> >   #define ELF_R_SYM   ELF64_R_SYM
> >   #define ELF_R_TYPE  ELF64_R_TYPE
> >   #endif
> >  +#define R_386_32           1            /* Direct 32 bit  */
> >  +#define R_386_PC32         2            /* PC relative 32 bit */
> >  +
> >  +#define R_ARM_PC24              1       /* PC relative 26 bit branch */
> >  +#define R_ARM_ABS32             2       /* Direct 32 bit  */
> >  +
> >  +#define R_MIPS_32               2       /* Direct 32 bit */
> >  +#define R_MIPS_26               4       /* Direct 26 bit shifted */
> >  +#define R_MIPS_HI16             5       /* High 16 bit */
> >  +#define R_MIPS_LO16             6       /* Low 16 bit */
> >
> >   /* The 64-bit MIPS ELF ABI uses an unusual reloc format. */
> >   typedef struct
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
