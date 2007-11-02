Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbXKBJH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbXKBJH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 05:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXKBJHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 05:07:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbXKBJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 05:07:21 -0400
To: casey@schaufler-ca.com
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
References: <520194.24968.qm@web36605.mail.mud.yahoo.com>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Fri, 02 Nov 2007 10:07:14 +0100
Message-ID: <873avp818d.fsf@olafdietsche.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1/6NDE34+1dUKogJr7Q56cZW7SKq/wv+tyiIjg
 p0YVcnRA5ALGE75IzxbFda3c6RFxVKSioG6EMHhQrFmRR7Pj16
 YZu5RLhDVDw7Kvg5CMCXw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> --- Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de> wrote:
>
>> The bits are stored in a sparse file named /.capabilities in the
>> directory of the mount point, where the corresponding executable
>> lives. The inode number of the file is the index into this file.
>
> The old PlanG approach. It's the way that we did MAC labels in
> Trix4. It has the wicked advantage of working across NFS without
> anyone being the wiser.

If you don't trust a NFS, you'll mount it nosuid anyway and then
fscaps are disabled too.

> It really causes trouble for backup utilities, however.

Whatever implementation you choose, you will always have to modify
your backup utilities or copy the attributes separately.

> Trix6 (there wasn't really a Trix5) had xattrs
> available and we found the switch well worth the investment.

Extended attributes are a nice, clean concept, like micro kernels for
example :-). But they have a cost, which shouldn't be ignored.

Regards, Olaf.
