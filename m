Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbXE3CjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbXE3CjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXE3Ci6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:38:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:31466 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXE3Ci5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NDsEj5xLUJNbUknfS9zPVbwYJlU78yqviXYx4EwANef0DeOwcJBg1AsViPzAGJFjbxzQN+ksPVfIyGllwNUfezpGyajHDoXWutPsAg+uyqxbSeWuYxPqpf8F1WO3ggd396RCOaoAybghOW2Oe/puam4QTdZUe9waDNmW9DQXVUA=
Message-ID: <9d732d950705291938n3f55c5cfr76103c696066bf9c@mail.gmail.com>
Date: Wed, 30 May 2007 11:38:48 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Cc: "James Morris" <jmorris@namei.org>, casey@schaufler-ca.com,
       "Andreas Gruenbacher" <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
	 <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
	 <Line.LNX.4.64.0705261442000.23020@d.namei>
	 <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com>
	 <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com>
	 <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com>
	 <4F828E03-DA6B-484E-A8F2-885D1BC6F23E@mac.com>
	 <9d732d950705280341x78575d85kaf95b0e2884723f3@mail.gmail.com>
	 <69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/29, Kyle Moffett <mrmacman_g4@mac.com>:
> >>> But writing policy with labels are somewhat indirect way (I mean,
> >>> we need "ls -Z" or "ps -Z").  Indirect way can cause flaw so we
> >>> need a lot of work that is what I wanted to tell.
> >>
> >> I don't really use "ls -Z" or "ps -Z" when writing SELinux policy; I
> >> do that only when I actually think I mislabeled files.
> >
> > I believe what you wrote, but it may not be as easy for average
> > Linux users.
>
> As I said before, average Linux users should not be writing their own
> security policy.  I have yet to meet an "average Linux user" who
> could reliably quote for me what the file permissions on the "/tmp"
> directory should be, or what the sticky bit was.  A small percentage
> of average Linux system administrators don't get that right
> consistently, and if you don't understand the sticky bit then you
> should *definitely* not be controlling program permissions on a per-
> syscall basis.

Thank you for your detailed and thoughtful explanation.
Things are much clear now for me. Although your explanation was
quite persuasive, I still have some concerns.

Linux is now being used literately everywhere. As devices, technologies and
Linux itself is evolving so quickly, I'm afraid the way you showed was right
but could never meet the every goal perfectly. So some areas, including
embedded and special distro I guess, there must be solutions and help  for
average level administrators.

I think there are two ways to make secure systems.  One is just
you wrote: "ask it professionals" way, the other is "making practices".
You might ask "how?" My answer to the question is pahtname-based
systems such as AppAmor and TOMOYO Linux.
They can't be compared to SELinux, but they should be considered to
supplemental tools.  At least they are helpful to analyze how Linux works.
Tweeking SELinux policy is not easy but writing policies for
them is relatively easy (I'm not talking about security here).

Not everybody can be a professional administrators, but he/she can be a
professional administrator of his/her system.  I believe there must be
solutions for non professional administrators.  That's why we developed
TOMOYO Linux (http://tomoyo.sourceforge.jp/) and so was AppArmor
I guess.  You might laugh, but we are doing this because we want to
contribute to Linux and its community. :)

Thanks,
Toshiharu Harada
