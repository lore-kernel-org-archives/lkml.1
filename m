Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbZE3SIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbZE3SIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 14:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761234AbZE3SH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 14:07:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:47808 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760767AbZE3SHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 14:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m2lLFOkDFyVLpGZgyCVSLUO+k9jcrrIGxnxRMU7R/bm+P+r5WLhPksN16oAX3irfaE
         4X30gWVHSeilEI8nJIAGqXcEo1gFbLOExL6HWkaJIz1VNldxy3EPDwzzb0nTxLUukaXl
         33XmVNo2m0PJiqBCBQJ0gOv1aUO63ixEuozjw=
MIME-Version: 1.0
In-Reply-To: <20090530134132.GA5969@nowhere>
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
	 <1242496922-6330-2-git-send-email-fweisbec@gmail.com>
	 <9b1675090905292005p2b53de7dy9e36f84368d76f01@mail.gmail.com>
	 <20090530032253.GA5999@nowhere>
	 <9b1675090905292123l7c3de4b6w897e153d60e5a469@mail.gmail.com>
	 <20090530134132.GA5969@nowhere>
Date: Sat, 30 May 2009 12:07:57 -0600
Message-ID: <9b1675090905301107t4884caccn937b0ccfd100d6aa@mail.gmail.com>
Subject: Re: [PATCH 1/2] kill-the-bkl/reiserfs: acquire the inode mutex safely
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 7:41 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, May 29, 2009 at 10:23:44PM -0600, Trenton D. Adams wrote:
>>
>> I was trying to imply that the patch might fix the problem I saw, not
>> that it was the cause.  I only though that because it mentioned a
>> potential deadlock, and it seems like that is what the problem I saw
>> was.
>
>
> Ah ok. No it's part of a tree which reworks the reiserfs locking scheme
> by removing the old one based on the legacy and obsolete bkl (big kernel
> lock). In this tree I had to fix several deadlocks or at least unsafe
> lock states because the bkl is converted into a mutex and some new lock
> dependencies were borned after that. But these issues had nothing
> to deal with upstream problems.
>
> BTW, would you be interested in giving a try with this reiserfs bkl
> removal tree? I really lack testing and feedbacks from users.

Well, the problem is that I only use reiserfs on my usb stick at the
moment.  So, the amount of testing I could do would be minimal at the
moment.  However, if I change my local filesystems to reiserfs, I will
remember to check back here for your patch.

Thanks.
