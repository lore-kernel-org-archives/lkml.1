Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZEWWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZEWWQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZEWWQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:16:11 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:44634 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZEWWQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <1243109591-21611-3-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1243109591-21611-3-git-send-email-ebiederm@xmission.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 24 May 2009 00:15:50 +0200
Message-ID: <ac3eb2510905231515m4f8633d9ga9e564e0a85c1e92@mail.gmail.com>
Subject: Re: [PATCH 23/20] driver core: Don't remove kobjects in 
	device_shutdown.
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
> device_shutdown is defined to just shutdown the hardware and to not
> clean up any kernel data structures.  Therefore don't put the kobjects
> for /sys/dev and /sys/dev/block and /sys/dev/char.
>
> This ensures we don't remove /sys/dev/block and /sys/dev/char while
> we still have symlinks from there to the actual devices.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Looks good.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Thanks,
Kay
