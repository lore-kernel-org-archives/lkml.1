Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbZBBS34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbZBBS34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBBS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:29:42 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:60421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbZBBS3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=rgcjquGJN5WrOJJ5dUQzqZg6cBT9UP6PQHS0lIC8EAHwPr+RmaOoMCBWgWktKtfu1y
         V2ydkC2Jk5oZpQq6Heqr4+CXKwr04qW2d6qyz5okmFrglYtWH599CXWhfkOuO7MnAR96
         MHiltNnGGM0aVcoVM+NE4O+CPvB/epnMc+9mk=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1233576952.4787.152.camel@laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <1233229028.4495.34.camel@laptop>
	 <1233237934.11129.183.camel@bugs-laptop>
	 <1233302270.6061.9.camel@marge.simson.net>
	 <1233560635.4126.18.camel@localhost.localdomain>
	 <1233562763.4787.71.camel@laptop>
	 <1233563600.3669.36.camel@localhost.localdomain>
	 <1233564731.21378.9.camel@marge.simson.net>
	 <1233564920.4787.108.camel@laptop> <1233576952.4787.152.camel@laptop>
Date: Tue, 3 Feb 2009 07:29:39 +1300
Message-ID: <cfd18e0f0902021029q6ccc5bd1q291582525ca54a2b@mail.gmail.com>
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or 
	synchronizing threads on different cores
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Thomas Pilarski <thomas.pi@arcor.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Feb 3, 2009 at 1:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-02-02 at 09:55 +0100, Peter Zijlstra wrote:
>
>> Ah, that was a good clue, apparently all you need to so it use
>> random_r() and provide your own state and all should be well.
>
> Michael, would it make sense to add the random_r() family to the "SEE
> ALSO" section of the random() man page?
>
> (Admittedly, my random() manpage is ancient: 2008-03-07, so it might be
> this is already the case, in which case, ignore me :)

(Up-to-date version of the pages can always be found online at the
location in the .sig.)

Well, the man page already had this text under notes:

       This  function  should  not  be  used  in  cases where multiple
       threads use random() and the behavior should  be  reproducible.
       Use random_r(3) for that purpose.

But it certainly doesn't hurt to have random_r(3) also listed under
the SEE ALSO, and I've added it for man-pages-3.18.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
