Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXKCDgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXKCDgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 23:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXKCDgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 23:36:25 -0400
Received: from 74-92-59-67-NewEngland.hfc.comcastbusiness.net ([74.92.59.67]:36935
	"EHLO shelob.surriel.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754855AbXKCDgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 23:36:24 -0400
Date: Fri, 2 Nov 2007 23:36:15 -0400
From: Rik van Riel <riel@surriel.com>
To: Valdis.Kletnieks@vt.edu
Cc: lsorense@csclub.uwaterloo.ca (Lennart Sorensen),
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071102233615.6dc90e35@bree.surriel.com>
In-Reply-To: <12100.1194059303@turing-police.cc.vt.edu>
References: <20071014190128.6e3cdb44@bree.surriel.com>
	<20071028180707.GA6111@ucw.cz>
	<20071029194820.GC27646@csclub.uwaterloo.ca>
	<20071029201911.GB3537@elf.ucw.cz>
	<20071029214452.GA27643@csclub.uwaterloo.ca>
	<12100.1194059303@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2007 23:08:23 -0400
Valdis.Kletnieks@vt.edu wrote:

> IBM's AIX supported file system compression on the JFS filesystem
> years ago. I was able to get up to 30% throughput increases by
> converting the /usr filesystem to compressed - because even a 33mhz
> Power chipset could read in 5 512-byte blocks and decompress it to
> the original 4K faster than the disk could read in 8 512-byte
> blocks. 

> Given that today there's an even *bigger* disparity in CPU speed
> versus disk speed, I'd be surprised if it doesn't help today too.

The problem is that disk seek times have not gotten much
faster over the years, while disk throughput rates have
skyrocketed.

Transferring a little less data is not going to help you
when 80% of your disk time is spent seeking, not reading
or writing.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
