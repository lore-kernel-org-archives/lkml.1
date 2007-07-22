Return-Path: <linux-kernel-owner+w=401wt.eu-S1763877AbXGVTR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763877AbXGVTR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXGVTRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:17:16 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:48809 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761391AbXGVTRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:17:14 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Smirl <jonsmirl@gmail.com>, Git Mailing List <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Git help for kernel archeology, suppress diffs caused by CVS keyword expansion
References: <9e4733910707221148g69d7600bk632abb7452ce9c7c@mail.gmail.com>
	<alpine.LFD.0.999.0707221205080.3607@woody.linux-foundation.org>
From: David Kastrup <dak@gnu.org>
Date: Sun, 22 Jul 2007 21:17:12 +0200
In-Reply-To: <alpine.LFD.0.999.0707221205080.3607@woody.linux-foundation.org> (Linus Torvalds's message of "Sun\, 22 Jul 2007 12\:09\:01 -0700 \(PDT\)")
Message-ID: <85644ci6yv.fsf@lola.goethe.zz>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, 22 Jul 2007, Jon Smirl wrote:
>>
>> It would really be useful if git diff had an option for suppressing
>> diffs caused by CVS keyword expansion.
>
> I really think it's not a "git diff" issue, but it might be a "import" 
> issue.
>
> IOW, I think you'd be a *lot* better off just not importing those
> things in the first place (which is what CVS does internally), or
> possibly importing them as two trees (ie you'd have the "non-log"
> version and the "log expansion" version, so that you can track and
> compare both).

One problem is that those strings more often than not are involved in
some magic computation, like placing version and date information into
extracted output.  While an import of the unexpanded version is really
the sanest option, it might render the resulting code inoperable.

CVS diff itself reports those differences, too (and it makes for a
good quota of merge problems even in CVS), so it is not like we are in
bad company here.

Uh, strike that.

-- 
David Kastrup, Kriemhildstr. 15, 44793 Bochum
