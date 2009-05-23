Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZEWVaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZEWVaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZEWV37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:29:59 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:43915 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZEWV36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:29:58 -0400
MIME-Version: 1.0
In-Reply-To: <1243109591-21611-4-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1243109591-21611-4-git-send-email-ebiederm@xmission.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 23 May 2009 23:29:39 +0200
Message-ID: <ac3eb2510905231429t3377f6e4ud0c53fc841122f2a@mail.gmail.com>
Subject: Re: [PATCH 24/20] sysfs: In sysfs_add_one fail if the targe directory 
	has been removed.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 22:13, Eric W. Biederman <ebiederm@xmission.com> wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
>
> If a bug in the upper layers results in someone attempting to add
> to a sysfs directory that has already been removed, warn about it
> and fail.
>
> I don't believe this has ever happened, and it certainly never should
> happen, but be strict to avoid errors creeping in.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Sounds like a good idea.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Thanks,
Kay
