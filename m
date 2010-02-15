Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0BOEuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:50:20 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:34384 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0BOEuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SCIZCj/1gjg7fKIjkCNRNKnr5dCiI+862QuBlMlHYL4b949xrTYqHd6C2v5bQBuWUq
         Vm0ShGKWFWYM4XMMgRppS4BAIDgN0iwZucMFrOIkFbRLqcT9WxsAi5PqbGT93rsnu0nE
         GOhIwgH1jONw8aTxhI5xOZCuwWQzkLpJW9qyA=
MIME-Version: 1.0
In-Reply-To: <21d7e9971002142046p2a3af2bak1a01bb7117db7841@mail.gmail.com>
References: <alpine.LRH.2.00.0912040030400.16314@tundra.namei.org>
	 <21d7e9971002142046p2a3af2bak1a01bb7117db7841@mail.gmail.com>
Date: Mon, 15 Feb 2010 14:50:17 +1000
Message-ID: <21d7e9971002142050w7d6205cex5c8af7310a0dfeb4@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 2.6.33
From: Dave Airlie <airlied@gmail.com>
To: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
       eparis@parisplace.org, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>>      SELinux: add .gitignore files for dynamic classes
>
> This isn't such a good idea I've discovered after wasting half my day
> wondering why 2.6.33-rc8 oops in selinux
> code when vbetool runs.
>
> The problem (not sure what we or git can do, hence Linus cc'ed) is:
>
> a) git tree contains 2.6.32 + with old non-generated versions of
> flash.h and av_permissions.h
> b) git pull 2.6.33-rc8, nothing removes these old files, git status
> doesn't show them as they are now in .gitignore
> c) build 2.6.33, it picks up the include files from the old location
> not from the generated ones in the new tree.
> d) bad juju.
>
> I'm also doing out of tree builds btw.

Also I realise git clean -dxf would have done this, but there is
nothing to say you need to clean -x except an oops when you build
the kernel, the fact that git status is clean means its quite annoying to find.

Dave.
