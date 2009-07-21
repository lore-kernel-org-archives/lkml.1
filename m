Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZGUA3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZGUA3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZGUA3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:29:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657AbZGUA3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:29:37 -0400
Date: Mon, 20 Jul 2009 17:28:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
In-Reply-To: <20090721101355.c32a0d27.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.01.0907201728170.19335@localhost.localdomain>
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de> <20090720150916.GB10015@suse.de> <20090720180333.GA2905@brouette> <alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
 <20090721101355.c32a0d27.sfr@canb.auug.org.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Jul 2009, Stephen Rothwell wrote:
> 
> ccache includes, in the hash of the preprocessed file, "the real compilers
> size and modification time", so will probably notice an upgrade or
> downgrade of the compiler.

Including something like the assembler? Apparently the problem here was 
binutils.

			Linus
