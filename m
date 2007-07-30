Return-Path: <linux-kernel-owner+w=401wt.eu-S1765911AbXG3PbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765911AbXG3PbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXG3PbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:31:01 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:35720 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbXG3PbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:31:00 -0400
Date: Mon, 30 Jul 2007 19:29:41 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] .gitignore update
Message-ID: <20070730152941.GA22756@localhost.sw.ru>
References: <20070726121547.GA16937@localhost.sw.ru> <Pine.LNX.4.64.0707291656380.9488@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707291656380.9488@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 04:57:22PM +0200, Jan Engelhardt wrote:
> 
> On Jul 26 2007 16:15, Alexey Dobriyan wrote:
> >
> >Somehow I ended up with the following in tree:
> >
> >	$ git status
> >		...
> >	# Untracked files:
> >	#   (use "git add <file>..." to include in what will be committed)
> >	#
> >	#       fs/proc/root.o.FuMxJQ
> >	#       net/ipv4/tcp_minisocks.o.geCDYR
> >
> >These are presumably temporary gcc files, which aren't interesting.
> 
> But they should not be there by default! Or are they?

Who knows. I straced a bit but rename(2) seems to not happen. However, this
is not the first time I see them, and yes, box is frequently rebooted
hard way.

> Looks like an interrupted assembler stage or so.

These *.o.* are normal but truncated corresponding *.o files.

> So I do not think *.o.* should be added.

