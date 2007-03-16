Return-Path: <linux-kernel-owner+w=401wt.eu-S2992436AbXCPWoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992436AbXCPWoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992442AbXCPWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:44:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:49140 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992436AbXCPWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GTE8s33SyYgUq6kBcxL/I33a7yRM8FQguq9H2qNgeUOCKEs1y5e0UABgfhou3QfMIogP8KHl4qSZ+yy4vDKPl/CTQojAv50hAVk/DVaM33djZlXzKYgvLLWcCk2bb2HxpE6/rWzg/h1MJsvME3t7g13mF10swp9bGCZQ7v0JlFM=
Message-ID: <b0943d9e0703161544h2961670dh8f5e499fd2dc0ce5@mail.gmail.com>
Date: Fri, 16 Mar 2007 22:44:14 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible "struct pid" leak from tty_io.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1slc4luf5.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	 <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	 <m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	 <m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	 <m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
	 <m1slc4luf5.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Catalin Marinas" <catalin.marinas@gmail.com> writes:
> > It seems to fix the leak. I looked at the logs and proc_set_tty calls
> > put_pid twice for pid 245 (the unresolved leak) and get_pid for pid
> > 296, which is later passed to put_pid via do_tty_hangup.
>
> Ok.  Any chance you could help me track down which application is
> ultimately calling proc_set_tty (I think it has pid 296 in your case).

I'll look at this on Monday since I was trying it on an ARM embedded
platform in the office (with a Debian filesystem).

-- 
Catalin
