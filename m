Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZATIf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZATIf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZATIfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:35:47 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48261 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZATIfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qPxSkw5PldGfJQ/j1oqjkqvvaRLzz64ZGlL+eM5pzXaGCKgqNjdJnLjUDKRWEMqMGo
         YjFrDFQWur4EmFjikfq+HjC45TjGgXEN9zrC/YyGtJmpfaWF7lLrsr2k2h94ZnICpvmu
         KwbfavZRpjD4m4e1fLoq6F2hNKt4ZRLkx0Z80=
Message-ID: <bcb3ef430901200035y33cea7e6hcf78ac1df01c99d2@mail.gmail.com>
Date: Tue, 20 Jan 2009 09:35:44 +0100
From: MartinG <gronslet@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Suspend/resume works in 2.6.29-0.19.rc0.git9.fc11.i686, but fails in later versions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090119191720.GB6463@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com>
	 <20090116085326.GC4795@atrey.karlin.mff.cuni.cz>
	 <bcb3ef430901161443y5843d951m1cdee28dd588d006@mail.gmail.com>
	 <20090119191720.GB6463@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 8:17 PM, Pavel Machek <pavel@suse.cz> wrote:
> Ok, that is not going to work on single core. Can you try if
> suspending works in init=/bin/bash mode?

Hi, I forgot to mention that I'm running on a crypted disk. So
"init=/bin/bash" fails. But I booted kernel-2.6.29-0.41.rc2.fc11.i686
using "1" as a kernel parameter, and put the laptop to suspend by
# echo -n mem > /sys/power/state

But still, I was not able to resume it - black screen, keyboard dead.

Could it be related to my disk encryption? I though "everybody"
encrypted their laptop these days?
I set it up during installation (full disk encryption, I get prompted
for passphrase as the first thing during boot).

This is my layout:
# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00
                       12G  7,5G  4,5G  63% /
/dev/mapper/VolGroup00-LogVol02
                       14G   12G  1,6G  88% /home
/dev/sda1             190M   51M  130M  29% /boot
tmpfs                 614M   76K  614M   1% /dev/shm

# mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/mapper/VolGroup00-LogVol02 on /home type ext3 (rw)
/dev/sda1 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
nfsd on /proc/fs/nfsd type nfsd (rw)

I'd be happy to test further - please let me know what info I can provide.
Thanks.

-MartinG
