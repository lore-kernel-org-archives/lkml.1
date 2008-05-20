Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbYETQlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbYETQlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765233AbYETQkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:40:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbYETQkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:40:49 -0400
Date: Tue, 20 May 2008 11:22:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
Message-ID: <20080520152227.GC542@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org> <20080502184922.GM14976@parisc-linux.org> <20080520032448.GA19348@redhat.com> <20080520071458.707d6e90@infradead.org> <20080520142727.GC4843@redhat.com> <b6fcc0a0805200800k10264445n59bb56d24b80cd2f@mail.gmail.com> <alpine.LFD.1.10.0805200806340.32253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805200806340.32253@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 08:12:41AM -0700, Linus Torvalds wrote:

 > So no, lists aren't "special" in any inherent way, they are just special 
 > in these kinds of "incidentally, a lot of random data structure corruption 
 > has traditionally shown up in lists, because there are so many of them".

It's also been _really_ useful for showing up random bit flips in bad hardware.

"hey, if that bit had been a 1, this pointer would have looked valid and we
 wouldn't have oopsed" has led to quite a few cases where the reporter then
found a session with memtest86 enlightening.

	Dave

-- 
http://www.codemonkey.org.uk
