Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYJIR3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYJIR3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYJIR3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:29:35 -0400
Received: from gw.goop.org ([64.81.55.164]:36381 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYJIR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:29:35 -0400
Message-ID: <48EE3F7B.6040802@goop.org>
Date: Thu, 09 Oct 2008 10:29:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Matthew Wilcox <matthew@wil.cx>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
 arch
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au> <20081008025209.GO25780@parisc-linux.org> <20081009122319.GC1623@ucw.cz>
In-Reply-To: <20081009122319.GC1623@ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> We have append-only files, and normal users should not be able to work
> around that restriction.

Well, apparently Posix breaks this, and we're supposed to let pwrite() 
write anywhere in an O_APPEND file.  So any security-related argument 
goes out the window.

    J
