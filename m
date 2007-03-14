Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXCNBGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXCNBGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 21:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXCNBGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 21:06:19 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:48188 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbXCNBGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 21:06:18 -0400
Subject: Re: [RFC/PATCH 00/59] Make common x86 arch area for i386 and x86_64
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <20070313214512.GM10574@sequoia.sous-sol.org>
References: <1173820919.28042.3.camel@localhost.localdomain>
	 <20070313214512.GM10574@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 21:05:16 -0400
Message-Id: <1173834316.30118.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 14:45 -0700, Chris Wright wrote:

> what about asm-x86/ dir?  the asm/ symlink would still point to relevant
> arch, but the file there could be simply #include <asm-x86/file.h> ?

Would it be acceptable to have an include/asm-x86/ dir with one file?
Of course it will open the door to merge current code and share it there
too.

-- Steve


