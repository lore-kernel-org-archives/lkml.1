Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZBBSfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZBBSfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZBBSfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:35:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47724 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZBBSfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:35:24 -0500
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or 
 synchronizing threads on different cores
From: Peter Zijlstra <peterz@infradead.org>
To: mtk.manpages@gmail.com
Cc: Mike Galbraith <efault@gmx.de>, Thomas Pilarski <thomas.pi@arcor.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <cfd18e0f0902021029q6ccc5bd1q291582525ca54a2b@mail.gmail.com>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <1233229028.4495.34.camel@laptop> <1233237934.11129.183.camel@bugs-laptop>
	 <1233302270.6061.9.camel@marge.simson.net>
	 <1233560635.4126.18.camel@localhost.localdomain>
	 <1233562763.4787.71.camel@laptop>
	 <1233563600.3669.36.camel@localhost.localdomain>
	 <1233564731.21378.9.camel@marge.simson.net>
	 <1233564920.4787.108.camel@laptop> <1233576952.4787.152.camel@laptop>
	 <cfd18e0f0902021029q6ccc5bd1q291582525ca54a2b@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 19:35:14 +0100
Message-Id: <1233599714.4787.221.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 07:29 +1300, Michael Kerrisk wrote:
> Hi Peter,
> 
> On Tue, Feb 3, 2009 at 1:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2009-02-02 at 09:55 +0100, Peter Zijlstra wrote:
> >
> >> Ah, that was a good clue, apparently all you need to so it use
> >> random_r() and provide your own state and all should be well.
> >
> > Michael, would it make sense to add the random_r() family to the "SEE
> > ALSO" section of the random() man page?
> >
> > (Admittedly, my random() manpage is ancient: 2008-03-07, so it might be
> > this is already the case, in which case, ignore me :)
> 
> (Up-to-date version of the pages can always be found online at the
> location in the .sig.)

Ah, I'll try to remember that.

> Well, the man page already had this text under notes:
> 
>        This  function  should  not  be  used  in  cases where multiple
>        threads use random() and the behavior should  be  reproducible.
>        Use random_r(3) for that purpose.

Yeah, but I found it eventually, but I generally don't read a full
manpage when I'm looking for related functions, only the SEE ALSO
section.

> But it certainly doesn't hurt to have random_r(3) also listed under
> the SEE ALSO, and I've added it for man-pages-3.18.

Thanks.

