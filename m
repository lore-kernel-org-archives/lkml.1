Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZFTTzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZFTTzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZFTTzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:55:07 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:40003
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752012AbZFTTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:55:06 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jun 2009 15:55:05 EDT
Date: Sat, 20 Jun 2009 15:48:24 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Badness on the Warp
Message-ID: <20090620154824.72b5cd50@lappy.seanm.ca>
Organization: PIKA
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEXOy8P+/f8hHBFoOhetjm76/P5qPzJLJxltXUSaX0wbgtjEAAACY0lEQVQ4jWWUQWvcMBCF91BCjiuIIWcX6nsE9uZWgknjWwW7sD2rjL1XGzzpNS2ufI5xVv+2byTHSehcbO8nzWjeG+1GqcPhZfTlEl8/hUdVbgDUvfNT+SEqH8Ho/UdQCjDJg0dMceVUhVcBKhn8Go7qTjd4CYCcBL7OQ9GmGXfNuICauaNmIKrbNGWivAngQPhMOScibODGOZ2PYUfdMlCnyTJWpFlu9SkW14Ps6cdZHoJ4F4ENPzxOD3i2cZMA9VCHdV/KCmdC3i7WMAKyNuNfZVUwzoA2pmqjDkZd1ikjfpblTDj32PhSwEH9GHTBrQDvpaXT9Aqc1cz9HwHedg20qkLxK2cLNIh1q8p+Ae53TsMJ36shAewdDPHz+B/YDqOffEhTvXMQYIbp0SppIdQKIIG31XwK4Pk2OrYAuGQX0JHUowDUPY1O77xkeob6CLsxYQfZvMhxNJhYsNY56bjjktA6Pgl6WIiLiOC6g1hQltMMIJBY/FrEhcRisIWcrG3csa8DEOt6pGs5HwIw2zrkCW6TCN0sQP2tuwjSmouWb10EiXrJcUwhqAzfx2aWaYe5F48k9qbBYplKFybRmGPvbuJIyUTKTAagkquabrJWcnV0OqONqFWSfH/qi52cDOvHs10bVOobgEb73NPoh1WSJDky72whkmDcVmCkCMuJU9Yn/y6VMWaGriTTiesmUxZTIS4yOIR5qPzZSbMr2LefcaB4P/V7kNxlvcY9xJnEQ70Cc2w7aCFXtBCnVqC2uCEiU2hz6TxuuUsz0TDy/C1Vcgwayh8AwFvxg9k/LTcWUfA/se5dIXIv87sAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    0.000000] ------------[ cut here ]------------
[    0.000000] Badness at c033ebc4 [verbose debug info unavailable]
[    0.000000] NIP: c033ebc4 LR: c033eb94 CTR: 00000000
[    0.000000] REGS: c037fe70 TRAP: 0700   Not tainted  (2.6.30-pika)
[    0.000000] MSR: 00021000 <ME,CE>  CR: 22022024  XER: 00000000
[    0.000000] TASK = c035b440[0] 'swapper' THREAD: c037e000
[    0.000000] <6>GPR00: 00000001 c037ff20 c035b440 00000000 0000000c 00000020 3fffffff 00000000 
[    0.000000] <6>GPR08: c036faa4 c0380000 c07b7586 00000000 22002022 00000000 0ffa7f00 007fff99 
[    0.000000] <6>GPR16: 00400450 00800000 007fff00 0ffa7a90 00000000 ffffffff 00000000 c0351d40 
[    0.000000] <6>GPR24: 00000000 00001229 c0386b1c 0000000c 00000020 00000000 3fffffff 0000000c 
[    0.000000] NIP [c033ebc4] alloc_arch_preferred_bootmem+0x48/0x74
[    0.000000] LR [c033eb94] alloc_arch_preferred_bootmem+0x18/0x74
[    0.000000] Call Trace:
[    0.000000] [c037ff20] [c0350fa8] 0xc0350fa8 (unreliable)
[    0.000000] [c037ff30] [c033ec40] ___alloc_bootmem_nopanic+0x50/0x108
[    0.000000] [c037ff60] [c033ed10] ___alloc_bootmem+0x18/0x50
[    0.000000] [c037ff70] [c033b3bc] uic_init_one+0x40/0x22c
[    0.000000] [c037ff90] [c033b630] uic_init_tree+0x88/0x168
[    0.000000] [c037ffb0] [c0337378] init_IRQ+0x28/0x40
[    0.000000] [c037ffc0] [c0334664] start_kernel+0x15c/0x2a0
[    0.000000] [c037fff0] [c0000200] skpinv+0x190/0x1cc
[    0.000000] Instruction dump:
[    0.000000] 2f830000 38600000 409e0018 80010014 83e1000c 7c0803a6 38210010 4e800020 
[    0.000000] 3d20c038 80095408 21600000 7c0b0114 <0f000000> 2f800000 409e0018 38800000 


I wouldn't trust the backtrace too much since it seems to keep
changing. It used to show __start_notes as the backtrace. This one is
with the head of Linus' tree as of a few minutes ago.

So I did a git bisect, and the problem goes back to June 11. The Warp
boots and seems to run fine. So I didn't notice until looking at the
logs for a different problem. I have since added a test to my
regression tests to look for badness or oops in the logs.

The git bisect returned:

  871fa90791a6f83dd8e2e489feb9534a8c02088d is first bad commit

That is it, no more info.... strange. git show 8714...088d gives:

Merge: 7702667... 79f52b7...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 11 11:27:09 2009 -0700

    Merge branch 'for-linus' of
    git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6 
    * 'for-linus' of
    git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6: jfs:
    Add missing mutex_unlock call to error path missing unlock in
    jfs_quota_write()

The Warp has jfs disabled, so I don't know why it would affect us,
especially this realy in the boot! Anyway, I tried to revert the patch:

$ git revert 871fa90791a6f83dd8e2e489feb9534a8c02088d
fatal: Commit 871fa90791a6f83dd8e2e489feb9534a8c02088d is a merge but no -m option was given.

So, anybody got an idea what is going on here? Or how I can revert the
patch. I am not a git expert, so if I am doing this wrong, let me know.

Cheers,
   Sean
