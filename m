Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbYDPDKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbYDPDKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 23:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYDPDKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 23:10:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:56765 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbYDPDKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 23:10:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xQCMHSmWTGsOzQd0BldfL2bZMlmB+DPCywZeSXwoHOj4AwbrmhYnsQOeAzoFDnb85pCDJf4EimIvuxkfJ7Ow2Wl9FsIdNcOkkouYnSf05X2jOlpnycELiW6wLCCNprWeF6aW68HvDomEkeVD560oBI0J/nS6ExVGLxHeAUxbtYM=
Message-ID: <af3ea28a0804152010g5a234640o94f39bbecf0d4637@mail.gmail.com>
Date: Wed, 16 Apr 2008 11:10:31 +0800
From: "ye janboe" <janboe.ye@gmail.com>
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH]kbuild: add arm, mips and i386 macros
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <af3ea28a0804092038q59a5b907ndb3d9fa33a6be834@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <af3ea28a0804092038q59a5b907ndb3d9fa33a6be834@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one think this patch is needed?

2008/4/10, ye janboe <janboe.ye@gmail.com>:
> commit a80cc2fe14ce7e7a6de70b5927b9c0a6ee530805
>  Author: janboe <janboe.ye@gmail.com>
>  Date:   Thu Apr 10 11:18:03 2008 +0800
>
>     the commits 56a974fa2d595fe6ebe433c525b8232ead539b76 and
>  ae4ac12323c0ff80528cac3269151d580e23f923
>     involved additional macros but not available on cygwin.
>  Signed-off-by: Janboe Ye <janboe.ye@gmail.com>
>  diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
>  index 09f58e3..f864ab8 100644
>  --- a/scripts/mod/modpost.h
>  +++ b/scripts/mod/modpost.h
>  @@ -42,6 +42,16 @@
>   #define ELF_R_SYM   ELF64_R_SYM
>   #define ELF_R_TYPE  ELF64_R_TYPE
>   #endif
>  +#define R_386_32           1            /* Direct 32 bit  */
>  +#define R_386_PC32         2            /* PC relative 32 bit */
>  +
>  +#define R_ARM_PC24              1       /* PC relative 26 bit branch */
>  +#define R_ARM_ABS32             2       /* Direct 32 bit  */
>  +
>  +#define R_MIPS_32               2       /* Direct 32 bit */
>  +#define R_MIPS_26               4       /* Direct 26 bit shifted */
>  +#define R_MIPS_HI16             5       /* High 16 bit */
>  +#define R_MIPS_LO16             6       /* Low 16 bit */
>
>   /* The 64-bit MIPS ELF ABI uses an unusual reloc format. */
>   typedef struct
>
