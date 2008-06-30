Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbYF3UIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbYF3UIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYF3UII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:08:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYF3UIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:08:05 -0400
Date: Mon, 30 Jun 2008 22:06:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andy Whitcroft <apw@shadowen.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30
Message-ID: <20080630200623.GE6584@elte.hu>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <48690385.7030500@linux.vnet.ibm.com> <48690D3C.1060803@linux.vnet.ibm.com> <20080630185943.GA24692@uranus.ravnborg.org> <20080630192610.GA6584@elte.hu> <20080630194727.GA26682@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630194727.GA26682@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Jun 30, 2008 at 09:26:10PM +0200, Ingo Molnar wrote:
> > 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > On Mon, Jun 30, 2008 at 10:13:40PM +0530, Kamalesh Babulal wrote:
> > > > Kamalesh Babulal wrote:
> > > > > Hi Stephen,
> > > > > 
> > > > > next-20080630 kernel build fails x86 box 
> > > > > 
> > > > > fs/bio-integrity.c: In function `bio_integrity_add_page':
> > > > > include/linux/bio.h:368: sorry, unimplemented: inlining failed in call to 'bvec_nr_vecs': function body not available
> > > > > fs/bio-integrity.c:135: sorry, unimplemented: called from here
> > > > > make[1]: *** [fs/bio-integrity.o] Error 1
> > > > > make: *** [fs] Error 2
> > > > > 
> > > > > # gcc -v
> > > > > Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
> > > > > Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> > > > > --infodir=/usr/share/info --enable-shared --enable-threads=posix
> > > > > --disable-checking --with-system-zlib --enable-__cxa_atexit
> > > > > --disable-libunwind-exceptions --enable-java-awt=gtk
> > > > > --host=i386-redhat-linux
> > > > > Thread model: posix
> > > > > gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)
> > > > > 
> > > > > 
> > > > Another build failure on the same box/config file
> > > > 
> > > > make[2]: `scripts/unifdef' is up to date.
> > > >   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
> > > > 101 section headers supported: 100
> > > > make[2]: *** [arch/x86/boot/compressed/vmlinux.relocs] Error 1
> > > > make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> > > > make: *** [bzImage] Error 2
> > > 
> > > In a i386 specific part of the kernel - so let's cc x86 maintainers.
> > 
> > that's an allyesconfig kernel and i cannot reproduce the failure with 
> > linux-next v2.6.26-rc8-6206-gf1c7436:
> > 
> >   [...]
> >   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
> >   BUILD   arch/x86/boot/compressed/vmlinux.bin.all
> >   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
> >   LD      arch/x86/boot/compressed/piggy.o
> >   LD      arch/x86/boot/compressed/vmlinux
> >   OFFSETS arch/x86/boot/offsets.h
> >   OBJCOPY arch/x86/boot/vmlinux.bin
> >   AS      arch/x86/boot/header.o
> >   LD      arch/x86/boot/setup.elf
> >   OBJCOPY arch/x86/boot/setup.bin
> >   BUILD   arch/x86/boot/bzImage
> >  Root device is (8, 17)
> >  Setup is 12524 bytes (padded to 12800 bytes).
> >  System is 17840 kB
> >  CRC bccb6201
> >  Kernel: arch/x86/boot/bzImage is ready  (#10848)
> > 
> > (nor has anything substantial change in that area changed in the x86 
> > tree recently that sticks out at first sight.)
> 
> Just to see the number of sections you hit could you try following stupid patch.
> It will casue relocs to terminate but will print out the section header count we have
> in your allyesconfig build.
> 
> It is 'funny' that we just passed the limit in the error report.
> 
> 	Sam
> 
> diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
> index edaadea..88d27f6 100644
> --- a/arch/x86/boot/compressed/relocs.c
> +++ b/arch/x86/boot/compressed/relocs.c
> @@ -244,7 +244,7 @@ static void read_ehdr(FILE *fp)
>  static void read_shdrs(FILE *fp)
>  {
>  	int i;
> -	if (ehdr.e_shnum > MAX_SHDRS) {
> +	if (1 || ehdr.e_shnum > MAX_SHDRS) {
>  		die("%d section headers supported: %d\n",
>  			ehdr.e_shnum, MAX_SHDRS);
>  	}

ah, ok. So the patch below should solve this for now?

is there any particular reason why we are limited to 100 sections? (is 
there some ELF limitation here perhaps?)

	Ingo

---------------->
commit db71d27cc7c76e5ff8dd44c7c8c40d1e216658d6
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 30 22:04:43 2008 +0200

    x86: increase MAX_SHDRS from 100 to 200
    
    Kamalesh Babulal reported this build failure:
    
     > make[2]: `scripts/unifdef' is up to date.
     >   RELOCS  arch/x86/boot/compressed/vmlinux.relocs
     > 101 section headers supported: 100
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index edaadea..668a48b 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -10,7 +10,7 @@
 #define USE_BSD
 #include <endian.h>
 
-#define MAX_SHDRS 100
+#define MAX_SHDRS 200
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf32_Ehdr ehdr;
 static Elf32_Shdr shdr[MAX_SHDRS];
