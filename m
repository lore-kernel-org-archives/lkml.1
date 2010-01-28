Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673Ab0A1Gtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0A1Gtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303Ab0A1Gto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:49:44 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:39248 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0A1Gtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=OX7joHHGri2DKwYeUlMP1sp4UcHNYGmTcl2wkKIAVZ4TFohj7A3N1Rp4V6/jTwmKlG
         /sRGPs37uYwceXSLMDrwlRY2sgCL5oU/GTclgm0YaMektauONM8wc5kKp3FgQA60JgND
         FjMHKocRHE+Xpyc4ExbAbOaaQRTerJfBOhbXI=
MIME-Version: 1.0
In-Reply-To: <daef60381001170536k2028f80bo7505a035cd7d637a@mail.gmail.com>
References: <daef60381001170536k2028f80bo7505a035cd7d637a@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 28 Jan 2010 14:49:23 +0800
Message-ID: <daef60381001272249v7bbc5ed5je41cd4dfc2db3470@mail.gmail.com>
Subject: Re: [PATCH] Fix bug of markup_oops.pl when first line of range is the 
	faulting instruction
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this mail.

I just sent a mail "[PATCH] markup_oops.pl: fix get "No matching code
found" when first line of range is the faulting instruction" for it.

Thanks,
Hui

On Sun, Jan 17, 2010 at 21:36, Hui Zhu <teawater@gmail.com> wrote:
> I got a "No matching code found" when I use markup_oops.pl parse a
> error in a x8664 module.
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffffa0000000>] init_module+0x0/0x10 [e]
> PGD 610a067 PUD 610b067 PMD 0
> Oops: 0002 [1] PREEMPT SMP
> CPU 0
> Modules linked in: e(+)
> Pid: 2064, comm: insmod Not tainted
> 2.6.27.39-WR3.0.2zz_standard-00073-g6471dad-dirty #3
> RIP: 0010:[<ffffffffa0000000>]  [<ffffffffa0000000>] init_module+0x0/0x10 [e]
> RSP: 0018:ffff8800060f5ef0  EFLAGS: 00000246
> RAX: ffff8800060f5fd8 RBX: ffffffffa0000340 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa0000000
> RBP: ffffffffa0000000 R08: 0000000000000000 R09: ffff880001101000
> R10: 0000000000000002 R11: 0000000000000472 R12: 0000000000000000
> R13: 00000000006905b0 R14: 00007fff7c934f15 R15: 0000000000000003
> FS:  000000000068f850(0063) GS:ffffffff80749040(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000006108000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 0000000000004000 DR7: 0000000000000000
> Process insmod (pid: 2064, threadinfo ffff8800060f4000, task ffff8800079078e0)
> Stack:  ffffffff8020903b 0000000000000000 ffffffff803a2fa1 0000000000000000
>  ffffffff8058ab82 0000000000000000 ffffffff80253e15 0000000000000001
>  ffffffffa0000340 000000000000c4ce ffffffffa0000340 000000000000c4ce
> Call Trace:
>  [<ffffffff8020903b>] ? _stext+0x3b/0x160
>  [<ffffffff803a2fa1>] ? __up_read+0x21/0xb0
>  [<ffffffff8058ab82>] ? _spin_unlock_irqrestore+0x12/0x40
>  [<ffffffff80253e15>] ? __blocking_notifier_call_chain+0x65/0x90
>  [<ffffffff80261e55>] ? sys_init_module+0xb5/0x210
>  [<ffffffff8020bb0b>] ? system_call_done+0x0/0x5
>
>
> Code: <c6> 04 25 00 00 00 00 03 31 c0 c3 0f 1f 44 00 00 f3 c3 90 90 04 00
> RIP  [<ffffffffa0000000>] init_module+0x0/0x10 [e]
>  RSP <ffff8800060f5ef0>
> CR2: 0000000000000000
> ---[ end trace 1f34257349e749de ]---
>
>
> 0000000000000000 <init_module>:
> init_module():
> /home/teawater/study/kernel/stack2core/example/e.c:10
>   0:   c6 04 25 00 00 00 00    movb   $0x3,0x0
>   7:   03
> /home/teawater/study/kernel/stack2core/example/e.c:13
>   8:   31 c0                   xor    %eax,%eax
>   a:   c3                      retq
>   b:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>
> 0000000000000010 <cleanup_module>:
> cleanup_module():
> /home/teawater/study/kernel/stack2core/example/e.c:20
>  10:   f3 c3                   repz retq
>  12:   90                      nop
>  13:   90                      nop
> Disassembly of section .modinfo:
>
> This is because the faulting instruction "movb   $0x3,0x0" is the
> first line of the range.
>
> In the markup_oops.pl:
> open(FILE, "objdump -dS --adjust-vma=$vmaoffset
> --start-address=$decodestart --stop-address=$decodestop $filename |")
> || die "Cannot start objdump";
>
> while (<FILE>) {
>        my $line = $_;
>        chomp($line);
>        if ($state == 0) {
>                if ($line =~ /^([a-f0-9]+)\:/) {
>                        if (InRange($1, $target)) {
>                                $state = 1;
>                        }
>                }
>        } else {
>                if ($line =~ /^([a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]+)\:/) {
>                        my $val = $1;
>                        if (!InRange($val, $target)) {
>                                last;
>                        }
>                        if ($val eq $target) {
>                                $center = $counter;
>                        }
>                }
> The first line cannot be eq, so $center cannot be set. I make a patch to fix it.
>
> Thanks,
> Hui
>
> Signed-off-by: Hui Zhu <teawater@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Ozan Çaglayan <ozan@pardus.org.tr>
> Cc: Matthew Wilcox <willy@linux.intel.com>
>
> ---
>  scripts/markup_oops.pl |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -204,7 +204,7 @@ if ($module ne "") {
>
>  my $counter = 0;
>  my $state   = 0;
> -my $center  = 0;
> +my $center  = -1;
>  my @lines;
>  my @reglines;
>
> @@ -236,7 +236,8 @@ while (<FILE>) {
>                                $state = 1;
>                        }
>                }
> -       } else {
> +       }
> +       if ($state == 1) {
>                if ($line =~ /^([a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]+)\:/) {
>                        my $val = $1;
>                        if (!InRange($val, $target)) {
> @@ -259,7 +260,7 @@ if ($counter == 0) {
>        exit;
>  }
>
> -if ($center == 0) {
> +if ($center == -1) {
>        print "No matching code found \n";
>        exit;
>  }
>
