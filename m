Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbYDUXcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbYDUXcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYDUXch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:32:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344AbYDUXcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:32:36 -0400
Date: Mon, 21 Apr 2008 16:32:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
In-Reply-To: <20080421231815.GS27459@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0804211630220.2779@woody.linux-foundation.org>
References: <20080421.153231.108090227.davem@davemloft.net> <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org> <20080421231815.GS27459@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Al Viro wrote:
> 
> FWIW, two things I _really_ want dead and gone are
> 	* timod (or full rewrite of that animal; current one is badly racy
> and plays fast and loose with way too many place in VFS guts)
> 	* altroot (use chroot, damnit, and bind whatever you need in there)

I heartily concur about the "altroot" thing. It should die. Removing that 
part from the Solaris/SunOS emulation is probably worthwhile, and then 
eventually when/if we end up having a working unionfs, that (along with 
solaros/sunos-emulation specific mounts) should be able to replace the 
need for altroot.

		Linus
