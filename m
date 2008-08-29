Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYH2IDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYH2IDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYH2IDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:03:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:13699 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbYH2IDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:03:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=vD52NZfPbwr84chEyPguZGYVEl0V2qNTakShm0KZ3HVUK7eSBGy/uKa5XXnxzYA4Jc
         ZV3HOcMYQim+INY0hhjUVvVaKoa21YPJlrD+HWcxVDriHCmEAj3bJsUZCkquPe7V4hUR
         IvjuKmOV8LjvyyiJLoDLq9sUV8veZS1BDF5ns=
Message-ID: <48B7AD4F.1070504@tuffmail.co.uk>
Date: Fri, 29 Aug 2008 09:03:27 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: kovlensky@interia.pl
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mounting windows shares with path exactly like on windows
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kovlensky@interia.pl wrote:

> I'm sorry to be slightly off topic, when it comes to this list, but I have
> no clue where to look for that and I think it can be doe on kernel level
> only.
>
> In short - I've got bunch of applications running both on windows and
> linux and these applications exchange links to files mounted on both
> sides. The problem is that these paths are different, i.e. like
> D:/dir/file on windows and /mountpoint/dir/file on Linux. What I need is
> unifying them. So my idea is to have path translator on anything on kernel
> level, which will make Linux open call to D:/dir/file on Linux work and
> open /mountpoint/dir/file. Was anything close to that ever incorporated in
> kernel?

Um, no.

More likely solutions are ptrace (intercept system calls using debugging
interface) or similar LD_PRELOAD magic (see fakeroot for an example).

> Applications are, as usual, closed source, and support for them, also as
> usual, answers "won't be fixed, switch to Windows, please". Very helpful.
>
> Any other ideas of solving this problem are also warmly welcomed. Also on
> windows side.

I thought modern windows supported unix-like mounts, a bit like the old
SUBST.EXE in dos.  So you could then mount all other drive letters as
subdirectories on the main drive.  Don't ask me how to do it though :-).

Alan
