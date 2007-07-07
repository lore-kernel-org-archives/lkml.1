Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXGGGuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXGGGuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 02:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXGGGuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 02:50:10 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:53786 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXGGGuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 02:50:08 -0400
Date: Sat, 7 Jul 2007 15:50:01 +0900
From: Mattia Dongili <malattia@linux.it>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: cpufreq 'choice' Kconfig oddness in 2.6.22-rc6-mm1..
Message-ID: <20070707065001.GA15181@inferi.kami.home>
References: <6443.1183782910@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6443.1183782910@turing-police.cc.vt.edu>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc4-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 12:35:10AM -0400, Valdis.Kletnieks@vt.edu wrote:
> So I was looking at drivers/cpufreq/Kconfig, and wondering...
> 
> Is there a specific reason why we have a 'choice' clause that allows selecting
> 'performance' or 'userspace' as the default governor, and no obvious way to
> select powersave, ondemand, or conservative as a default? Or was this an

Yes, ondemand and conservative may refuse to load/work on systems with
a high transition latency and that is sometimes discovered only at
runtime. This makes them not selectable as default governors.

> oversight I should cook up a patch for?  Looks like the Kconfig and a bit
> of cut-n-paste in include/linux/cpufreq.h is all that's needed?

No, some more work is needed (e.g.: falling back to a different governor
if the selected fails). Thomas Renninger has posted patches on
cpufreq-devel to accomplish that.

cheers
-- 
mattia
:wq!
