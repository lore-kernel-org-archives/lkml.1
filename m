Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZEWV2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZEWV2C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZEWV1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:27:52 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:44871 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZEWV1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:27:52 -0400
MIME-Version: 1.0
In-Reply-To: <1243109591-21611-5-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1243109591-21611-5-git-send-email-ebiederm@xmission.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 23 May 2009 23:27:32 +0200
Message-ID: <ac3eb2510905231427x62efaecfod2b11472fcdbcc21@mail.gmail.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
	directories.
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
> I have looked and I have not found a single legitimate case today where
> we remove sysfs directories with anything in them.  The only case I have
> found to date was a bug.  It was a problem of ownership.  The files in
> the directory where not owned by the directory itself.   Leaving open
> the potential for double deletion of the directory contents.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Sounds good to me. We should try that, and see if there was any valid
use case we didn't think of, and if not, it's good to do what this
patch does.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Thanks,
Kay
