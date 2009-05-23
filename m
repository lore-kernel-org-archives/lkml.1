Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZEWVdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZEWVdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZEWVdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:33:06 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:48632 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZEWVdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:33:04 -0400
MIME-Version: 1.0
In-Reply-To: <1243109591-21611-2-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1243109591-21611-2-git-send-email-ebiederm@xmission.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 23 May 2009 23:32:44 +0200
Message-ID: <ac3eb2510905231432v15ac60b7id3f3041ded958e30@mail.gmail.com>
Subject: Re: [PATCH 22/20] sysfs: Make sysfs_rename_link atomic
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 22:13, Eric W. Biederman <ebiederm@xmission.com> wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
>
> Use the existing sysfs_rename to make sysfs_rename_link an atomic
> operation that does less work.  While I am at add additional sanity
> checking to ensure it is a symlink I am renaming.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Looks great, and so much better than the remove and re-create thing.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Thanks,
Kay
