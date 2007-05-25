Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXEYIBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXEYIBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXEYIBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:01:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:36801 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXEYIBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MnfptnTiGTGMw8LDjw8YFs7vS/7+6uD/TGhDpRxU8gOWsOJgFwnMELystf9uI+nrHgPEXv8jAKc6nJ5+5B9oDltjHWLq6x8J8RTjtbWSJgEfktUPMKs/in5ZKdlTWOkb4JVz0A7jqghsy/6UXqn51bdW7McyrOeqUo3YaSb9lUw=
Message-ID: <9d732d950705250101x13351c59y4afc4748aa73264b@mail.gmail.com>
Date: Fri, 25 May 2007 17:01:20 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Cc: "Andreas Gruenbacher" <agruen@suse.de>, "Al Viro" <viro@ftp.linux.org.uk>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, "Tony Jones" <tonyj@suse.de>
In-Reply-To: <Line.LNX.4.64.0705240858190.6121@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412090809.917795000@suse.de>
	 <200705232106.28260.agruen@suse.de>
	 <Line.LNX.4.64.0705232109030.3178@d.namei>
	 <200705241112.41101.agruen@suse.de>
	 <Line.LNX.4.64.0705240858190.6121@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/5/24, James Morris <jmorris@namei.org>:
> I can restate my question and ask why you'd want a security policy like:
>
>  Subject 'sysadmin' has:
>     read access to /etc/shadow
>     read/write access to /views/sysadmin/etc/shadow
>
> where the objects referenced by the paths are identical and visible to the
> subject along both paths, in keeping with your description of "policy may
> allow access to some locations but not to others" ?

If I understand correctly, the original issue was whether to allow passing
vfsmount to the inode_create LSM hook or not. Which is independent from
AA or "pathname based MAC", I think.

It is proven that Linux can be used without that change,　however it is
also clear that current LSM cause the ambiguities as AA people has
explained. Clearing ambiguities is a obvious gain to Linux and will make
benefits for auditing besides "pathname based MAC".

So here's my opinion. If anybody can't explain clear reason (or needs)
to keep these ambiguities unsolved,　we should consider to merge
the proposal.

Thanks.

-- 
Toshiharu Harada
haradats@gmail.com
