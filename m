Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYEQHao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYEQHao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYEQHaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:30:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43649 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYEQHae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:30:34 -0400
Date: Sat, 17 May 2008 01:30:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michal Simek <monstr@seznam.cz>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, rth@twiddle.net,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: Locking API testsuite problem - Microblaze
Message-ID: <20080517073032.GA2638@parisc-linux.org>
References: <482E8438.2040201@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482E8438.2040201@seznam.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 09:07:36AM +0200, Michal Simek wrote:
> Hi Richard, Tony, Arnd and others,
> 
> I turn on API testsuite for Microblaze CPU for stable 2.6.24 and I got nice log
> with some faults. The same problem I have on latest version.
> 
> I found the similar problem for alpha CPU and ia64 but I haven't found solving
> these issues. Could you give me a hint how to solve this problem.

You missed the crucial line:

143 out of 218 testcases failed, as expected.

Some of these testcases are /expected/ to fail.  Succeeding would be an
bug.  There are no bugs here.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
