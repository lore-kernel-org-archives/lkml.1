Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXFGHPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXFGHPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXFGHP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:15:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:28868 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXFGHP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KbGZFII0silOtNA3LCr/Wb1RAZN6REJnWA9anh3ZTsfGvq6yBF/qpV2lAatEurO1Te/NABj5sB+0X9063GDPuy0r+7O6DDD92GeJ34BMaVZ7aidv0dsn4rs+HSCuOQGqNyVXvEGQSIltU4srW2XRhh2MNz1fiI//e2JoMWqfLWw=
Message-ID: <4667B095.5050508@gmail.com>
Date: Thu, 07 Jun 2007 09:15:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>	<4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com> <4667A93A.4060608@gmail.com> <4667AD3F.1010405@gmail.com> <4667AF20.4020209@gmail.com>
In-Reply-To: <4667AF20.4020209@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo napsal(a):
> Jiri Slaby wrote:
>> Yes. Now I'm compiling -rc4-mm2.
> 
> It's probably caused by new sysfs slimdown patches and I'm pretty sure
> -rc4-mm2 would fail the same way.  The offending one should be one of
> the following patches.

There's reverted gregkh-driver-block-device in -mm2. So I wanted to give it a
try. Do you think it's pointless and that patch has no impact on the behaviour?

> gregkh-driver-sysfs-fix-parent-refcounting-during-rename-and-move.patch
> gregkh-driver-sysfs-reorganize-sysfs_new_indoe-and-sysfs_create.patch
> gregkh-driver-sysfs-use-iget_locked-instead-of-new_inode.patch
> gregkh-driver-sysfs-fix-root-sysfs_dirent-root-dentry-association.patch
> gregkh-driver-sysfs-move-s_active-functions-to-fs-sysfs-dirc.patch
> gregkh-driver-sysfs-slim-down-sysfs_dirent-s_active.patch
> gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch
> 
> Can you bisect the above patches?

Sure, in 12 hours or tomorrow.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

