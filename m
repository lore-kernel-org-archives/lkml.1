Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZJ2REh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZJ2REh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 13:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZJ2REh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 13:04:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbZJ2REg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 13:04:36 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Joseph S. Myers" <joseph@codesourcery.com>, linux-api@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <onestero@redhat.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
X-Yow: I don't know WHY I said that..  I think it came from the FILLINGS
 in my rear molars..
Date: Thu, 29 Oct 2009 18:03:48 +0100
In-Reply-To: <1254691822.21044.9.camel@laptop> (Peter Zijlstra's message of
	"Sun, 04 Oct 2009 23:30:22 +0200")
Message-ID: <m3k4yew2rv.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> On Sun, 2009-10-04 at 12:35 +0000, Joseph S. Myers wrote:
>> In asm-generic/fcntl.h, F_SETOWN_EX and F_GETLK64 both have value 12, and 
>> F_GETOWN_EX and F_SETLK64 both have value 13.  I don't see how this is 
>> going to work correctly.  See 
>> <http://sourceware.org/ml/libc-ports/2009-10/msg00013.html>.
>
>
> Ugh,.. yeah, non obvious collision that.
>
> How about something like:

That really needs to be fixed before 2.6.32.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
