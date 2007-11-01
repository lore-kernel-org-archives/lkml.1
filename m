Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbXKAWXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbXKAWXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXKAWWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:22:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbXKAWWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:22:53 -0400
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
References: <871wbhc0zj.fsf@olafdietsche.de>
	<20071031170853.GD28809@atrey.karlin.mff.cuni.cz>
	<87tzo5925v.fsf@olafdietsche.de> <20071101215424.GA27788@duck.suse.cz>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Thu, 01 Nov 2007 23:22:51 +0100
In-Reply-To: <20071101215424.GA27788@duck.suse.cz> (Jan Kara's message of "Thu\, 1 Nov 2007 22\:54\:24 +0100")
Message-ID: <87fxzp8v2c.fsf@olafdietsche.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18tcLm10cREaf1Zhd1FItRb/zj9agzqm7CkfrA
 T5Ym4w7jkgPlSph2U4Ob8mb21IP9vrc0fEkIZbh+zW1Tb/0qv9
 YYu3ixDgfMvnBrkNE3cfg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Thu 01-11-07 20:49:32, Olaf Dietsche wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> >> This patch implements filesystem capabilities. It allows to
>> >> run privileged executables without the need for suid root.
>> >   Hmm, is there some "design document" so that one does not have to poke
>> > through the code and find out what it's actually trying to do?
>> 
>> What do you mean with "trying to do"? I thought this is obvious, it
>> provides executables with filesystem capabilities.
>   Well, yes, that was obvious but I rather meant "how is it doing it?".
> So where does it store these bits and such.

The bits are stored in a sparse file named /.capabilities in the
directory of the mount point, where the corresponding executable
lives. The inode number of the file is the index into this file.

Regards, Olaf.
