Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbYECSB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbYECSB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbYECSBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:01:46 -0400
Received: from brmea-mail-4.Sun.COM ([192.18.98.36]:44916 "EHLO
	brmea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbYECSBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:01:45 -0400
Date: Sat, 03 May 2008 13:59:46 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Offtopic to: LogFS merge
In-reply-to: <alpine.LFD.1.10.0805031014300.5994@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Reply-to: davecb@sun.com
Message-id: <481CA812.2030404@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080502133234.GA24080@logfs.org>
 <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org>
 <20080502202151.GB24080@logfs.org>
 <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org>
 <20080502213146.GD24080@logfs.org>
 <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org>
 <20080502215833.GG24080@logfs.org> <20080503070318.GR8474@1wt.eu>
 <alpine.LFD.1.10.0805031014300.5994@woody.linux-foundation.org>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The real issue for me wrt a filesystem is the on-disk layout.
> 
> If we know that on-disk structures need change, we shouldn't merge it. It 
> doesn't matter if that can be worked around with some backwards- 
> compatibiltiy flag: we should simply not encourage that kind of behaviour.

  I agree in particular, but not in principle (;-))

  Changing the filesystem format was something that happened at
least twice on Multics, on production machines. I happened to be
on during one of the changes and didn't even know it was happening
until there was a broadcast message warning of poor performance.

  I always thought that was cool, and got permission recently to
post a colleague's paper on it at http://www.multicians.org/stachour.html

  It would be cool if data could change at run-time on Linux, just
like security-sensitive code.

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
