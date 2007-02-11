Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbXBKGbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbXBKGbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXBKGbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:31:53 -0500
Received: from rwcrmhc13.comcast.net ([204.127.192.83]:43271 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbXBKGbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:31:50 -0500
Date: Sat, 10 Feb 2007 22:02:55 -0800
From: Christopher Li <sparse@chrisli.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>, linux-sparse@vger.kernel.org,
       linux kernel mail list <linux-kernel@vger.kernel.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [ANNOUNCE] sparse-0.2-cl2 is now available
Message-ID: <20070211060255.GA2312@chrisli.org>
References: <20070204085329.GA6520@chrisli.org> <20070210000055.GA19968@chrisli.org> <p73hctthq8q.fsf@bingen.suse.de> <20070211051758.GA2113@chrisli.org> <20070211055015.GR10050@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211055015.GR10050@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 05:50:15AM +0000, Al Viro wrote:
> 
> I have some stuff in that direction, but it take some resurrecting...

OK, we should talk.

Here is what I have:

Linearize bytecode writer, which produce the binary linearized code.
The uncompress size is about 10 times the i386 .o file. I don't have
the loader ready to verify it yet. It is aim at fast loading bytecode
and simple, I havn't done much toward optimized the code size.

If we keep it 10 times over head, my home computer can load the full linux
kernel and have some spare for checking.

I am still working on the bytecode loader and linker for merging symbols.
It need to answer the question:

Which file define which function.
Which external symbol does this function use.

Once we get the function user/define chain, it can enable a lot of new checking.

The current linearized code is not very friendly to linking because we
keep abstract declare and real declare as different node. Depend on the
position, the caller will get different node even in one file.
 
I am going to take out the LKML on later email because discussion is
more sparse specific now.

Chris

