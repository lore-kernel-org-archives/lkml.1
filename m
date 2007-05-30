Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbXE3KH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbXE3KH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXE3KHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:07:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33789 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751396AbXE3KHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:07:11 -0400
Date: Wed, 30 May 2007 11:06:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Crispin Cowan <crispin@novell.com>
Cc: Valdis.Kletnieks@vt.edu, Kyle Moffett <mrmacman_g4@mac.com>,
       Toshiharu Harada <haradats@gmail.com>, James Morris <jmorris@namei.org>,
       casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
Message-ID: <20070530110658.31460b2b@the-village.bc.nu>
In-Reply-To: <465D111C.6060500@novell.com>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
	<B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
	<Line.LNX.4.64.0705261442000.23020@d.namei>
	<9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com>
	<EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com>
	<9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com>
	<4F828E03-DA6B-484E-A8F2-885D1BC6F23E@mac.com>
	<9d732d950705280341x78575d85kaf95b0e2884723f3@mail.gmail.com>
	<69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com>
	<8219.1180473430@turing-police.cc.vt.edu>
	<465D111C.6060500@novell.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> honest, even average-level system administrators should not be  
> >> writing security policy.
> That explains so much! "SELinux: you're too dumb to use it, so just keep
> your hands in your pockets." :-)

Hardly. And there are helper tools
> 
> AppArmor was designed to allow your average sys admin to write a
> security policy. 

Which is a bit like giving a small child an Uzi 9mm and inviting them to
teach themselves to shoot.

> Both SELinux and AppArmor can be configured so tightly that you are not
> going to get to install malware, by preventing the user from installing
> software. This isn't what users want, so they invariably bypass security
> and install shiny things if they own the box. SELinux and AppArmor can't
> help but fail if you put them in that kind of harm's way.

That depends who owns the admin password. That kind of thing (coupled
with 'can install approved packages' and suitable policy) works very well
in some environments where the user doesn't get the admin password - ie
much of business.
