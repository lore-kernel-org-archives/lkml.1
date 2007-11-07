Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbXKGOmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbXKGOmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758431AbXKGOm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:42:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:60640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbXKGOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:42:27 -0500
To: Jan Kara <jack@suse.cz>
Cc: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
References: <871wbhc0zj.fsf@olafdietsche.de>
	<20071031170853.GD28809@atrey.karlin.mff.cuni.cz>
	<87tzo5925v.fsf@olafdietsche.de> <20071101215424.GA27788@duck.suse.cz>
	<87fxzp8v2c.fsf@olafdietsche.de> <20071105110925.GC9561@duck.suse.cz>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Wed, 07 Nov 2007 15:42:20 +0100
In-Reply-To: <20071105110925.GC9561@duck.suse.cz> (Jan Kara's message of "Mon\, 5 Nov 2007 12\:09\:26 +0100")
Message-ID: <87r6j26rsj.fsf@olafdietsche.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+k+2DIm6JhOL/huMXYuiB7EjNTsPA6an7p9p7
 A2S7V4mvzhZCOT57uv3XPNyuO+UBQtz2VQsVEh0Ea7zjkTWZ4q
 7F4nSXvUxu7liBT8S0E+Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Thu 01-11-07 23:22:51, Olaf Dietsche wrote:
>> 
>> The bits are stored in a sparse file named /.capabilities in the
>> directory of the mount point, where the corresponding executable
>> lives. The inode number of the file is the index into this file.
>   Thanks for explanation. I guess I should warn you a bit :) Quota stores
> it's data (which are in a certain sence filesystem metadata) in regular
> files and believe me it brings some unexpected complexity. Especially
> avoiding deadlocks with journaled filesystems was quite complex for quotas
> (you cannot call filesystem write function when a transaction is already
> started or deadlocks can happen).

Thanks for this hint. I will investigate this, if time permits. To be
honest, I use and test with ext2 exclusively.

>   I guess with capabilities you need to write to the file only in some
> special situations but still you could have problems with that.

Regards, Olaf.
