Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbZCVKlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbZCVKlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZCVKla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:41:30 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48250 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZCVKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kxsX2105wzGLwX5OLkU4YKlUKLJeAVZj/Ir4VqhdnZpkO28IkrqONI8ewVfY86OqHl
         rrWkUkHF5Xal5uHs7dkoBBaOVXXwL0nummdGFruq/m5ligF4mD43Gz9lHKWRV9L3tjrG
         +oTfy77t/R6y3nq6Ou5veICVp7SUxTazUTyzY=
MIME-Version: 1.0
In-Reply-To: <20090322092025.GA4500@piper.oerlikon.madduck.net>
References: <b410963b0903211329v3c4d787ep2f7a0587bee77789@mail.gmail.com>
	 <20090322092025.GA4500@piper.oerlikon.madduck.net>
Date: Sun, 22 Mar 2009 12:41:25 +0200
Message-ID: <b410963b0903220341o43ea38afx6d2af6443e306118@mail.gmail.com>
Subject: Re: raid6 grow "hangs" on 2.6.27 with mounted FS
From: roma1390 <roma1390@gmail.com>
To: roma1390 <roma1390@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 11:20, martin f krafft <madduck@madduck.net> wrote:
> also sprach roma1390 <roma1390@gmail.com> [2009.03.21.2129 +0100]:
>> # add block device and grow, wait for resync
>> mdadm --add /dev/md2  /dev/loop5
>> mdadm --grow /dev/md2 --raid-devices=5
>> sleep 3
>>
>> # dmesg prints: VFS: busy inodes on changed media.
>> # umount hangs ...
>> umount /dev/md2
>
> I suggest unmounting before growing?

So this hang is by design? I think it must return EBUSY if can't
continue operation.
Documentation claims than Linux MD can grow online for raid5 and
raid6, like You can resize online ext3 FS.
