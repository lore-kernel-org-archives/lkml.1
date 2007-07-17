Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXGQLML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXGQLML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXGQLL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:11:58 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2907 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342AbXGQLL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:11:58 -0400
Date: Tue, 17 Jul 2007 13:12:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Message-ID: <20070717131255.71b7e72e@hyperion.delvare>
In-Reply-To: <20070717034844.GB11602@suse.de>
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 16 Jul 2007 20:48:44 -0700, Greg KH wrote:
> On Sun, Jul 15, 2007 at 12:42:32PM +0200, Jean Delvare wrote:
> > I'm running 2.6.22-git5 and noticed that the link count of the sysfs
> > root is broken:
> > 
> > $ ls -ld /sys
> > drwxr-xr-x 2 root root 0 Jul 15 12:27 /sys
> > 
> > sysfs is mounted, the link count should be 11, and is with kernel
> > 2.6.22.1. find(1) complains about the bad link count.
> 
> I suggest updating your version of find(1), I get no such complaint
> with:
> 	$ find --version
> 	GNU find version 4.3.8
> 	Built using GNU gnulib version 2007-05-26
> 	Features enabled: D_TYPE O_NOFOLLOW(enabled) LEAF_OPTIMISATION FTS() CBO(level=0)
> 
> What are you using?

$ find --version
GNU find version 4.2.28
Features enabled: D_TYPE O_NOFOLLOW(enabled) LEAF_OPTIMISATION

This is the standard version in openSuse 10.2. But how does it matter?
sysfs is broken, not find(1). Don't you see the sysfs root link count
at 2 as I do? This needs to be fixed.

-- 
Jean Delvare
