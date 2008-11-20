Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYKTLuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYKTLuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYKTLuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:50:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:28914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYKTLuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=gf1nYjQiZhIJmnDHI77clhLdjRyWXCoiTGfhsT4z5+tN2VsHnOMTvZ5bY7CXTxA/Z1
         676uIDhYkRw46bKuqj3+DGju1l+b+D0PBx8LaSNcrpvgJ4eXJedKqlTkQc4nbt13hI3m
         h8nrdGwJnAGhR/L1fZhqpFItfMXAJB7UteXrI=
Message-ID: <cfd18e0f0811200349q788c2767i5164dc1c47e67925@mail.gmail.com>
Date: Thu, 20 Nov 2008 06:49:54 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Current state of CLONE_NEWUSER?
Cc: "Serge Hallyn" <serue@us.ibm.com>,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru
In-Reply-To: <m1vdujdvi6.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0811191204r4ccaeaf4m4145e67f408543e0@mail.gmail.com>
	 <m1vdujdvi6.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, Nov 19, 2008 at 8:41 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Michael Kerrisk" <mtk.manpages@googlemail.com> writes:
>
>> Hi Serge,
>>
>> What is the current status of CLONE_NEWUSER?  I'm currently trying to
>> test this flag in preparation for documenting it in the clone(2) man
>> page, but am running into an ENOMEM error from the clone() call, which
>> seems to occur after a failure in kobject_init_and_add() in the
>> following call sequence:
>>
>> clone_user_ns() --> alloc_uid() --> uids_user_create() -->
>> kobject_init_and_add()
>>
>> Are there already some test programs somewhere?  Is there any
>> documentation already available for this flag?
>
> This code is definitely still under development.
>
> When complete it should be able to create a new uid namespace,
> as an unprivileged user.  Creating a new process with uid == gid == 0.
> Have a full set of caps.  And have permission to do nothing on the system
> except read world readable files and write world writable files.

Thanks for the info,

So the error I described is expected?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
