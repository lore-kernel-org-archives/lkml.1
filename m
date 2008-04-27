Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYD0Vfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYD0Vfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 17:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYD0VfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 17:35:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:30274 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYD0VfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 17:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=v1GZQAGJ80J19rHTn453ctaVaZ8qf2ns1xtui0h97MutwJBpMGuW4afcOwnRuW5HbK4xvHRCtJNsj7OMbc1xBtXolki8plxGg35bSmV+LRFk3DMHJT4cYPaeN4EbQICaUjgV1YsHvKMl/KZOVVBGwmUyKKCXJ9QqGXHpj11MRlk=
Date: Sun, 27 Apr 2008 23:35:23 +0200 (CEST)
To: Nick Clifton <nickc@specifixinc.com>
cc: Richard Henderson <rth@redhat.com>, Ian Taylor <ian@airs.com>,
       Jeff Law <law@redhat.com>, Jim Wilson <wilson@redhat.com>,
       DJ Delorie <dj@delorie.com>, Alan Modra <amodra@bigpond.net.au>,
       Michael Meissner <meissner@redhat.com>,
       Daniel Jacobowitz <dan@debian.org>, linux-kernel@vger.kernel.org,
       "Patrick J. Volkerding" <volkerdi@slackware.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: ld: <...> internal error, aborting at arange-set.c line 202 in
 arange_set_new
Message-ID: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For your information;
I just test build Linus' tip of the kernel tree (HEAD at 
064922a805ec7aadfafdd27aa6b4908d737c3c1d) on a up-to-date 
Slackware-current distro and hit this problem:

...
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
ld: size of bfd_vma > size of splay_tree types
ld: BFD (Linux/GNU Binutils) 2.18.50.0.4.20080208 internal error, aborting 
at arange-set.c line 202 in arange_set_new

ld: Please report this bug.

make: *** [.tmp_vmlinux1] Error 1

These are the versions of the tools used :

$ scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux dragon 2.6.25-03562-g3dc5063 #1 SMP PREEMPT Wed Apr 23 22:54:05 CEST 
2008 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD 
GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.18.50.0.4.20080208
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.8
jfsutils               1.1.12
reiserfsprogs          3.6.19
xfsprogs               2.9.7
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   118
Modules Loaded         snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss 
snd_mixer_oss agpgart lp snd_emu10k1 snd_rawmidi firmware_class 
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc 
snd_util_mem sg via_rhine snd_hwdep evdev ehci_hcd k8temp

.config is available on request, as is any other info that you may 
need/want.


Kind regards,
  Jesper Juhl <jesper.juhl@gmail.com>


