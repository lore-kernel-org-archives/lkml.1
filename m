Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYFWNxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYFWNxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYFWNxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:53:39 -0400
Received: from mx.treblig.org ([80.68.94.177]:45253 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYFWNxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:53:38 -0400
Date: Mon, 23 Jun 2008 14:53:37 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: linux-kernel@vger.kernel.org
Subject: mmap_min_addr/SECURITY_DEFAULT_MMAP_MIN_ADDR suggested values
Message-ID: <20080623135337.GE846@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.23.1-bytemark-uml (i686)
X-Uptime: 14:42:20 up 12 days, 21:11,  1 user,  load average: 0.02, 0.02, 0.03
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  The config help for SECURITY_DEFAULT_MMAP_MIN_ADDR suggests 65536
as a 'reasonable' value for x86 and the original mmap_min_addr
patches suggested that 'something like 64k' was a safe value that
wouldn't affect most programs.

  Where does this 64k value come from?  A number of distros seem
to have followed this advice and have it set to 64k; but is there
really any likely benefit of having it larger than PAGE_SIZE say?

I ask because I have an ancient program that maps stuff at 8k; the
general advice of stuff on the net seems to be to set this limit
to 0 if people have problems (I'm just lowering it to 4k),
but I was thinking perhaps using a lower default value would be more
secure since less people would take the easy answer and just turn the
feature off altogether.

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
