Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbZACOyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbZACOyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 09:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZACOxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 09:53:54 -0500
Received: from 1wt.eu ([62.212.114.60]:1083 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZACOxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 09:53:54 -0500
Date: Sat, 3 Jan 2009 15:50:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: davej@redhat.com, jschopp@austin.ibm.com, apw@uk.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: scripts/checkpatch.pl in 2.4 git
Message-ID: <20090103145024.GB21058@1wt.eu>
References: <3f9a31f40901030534v268d315ep4f1241042fafc456@mail.gmail.com> <20090103134558.GA21058@1wt.eu> <3f9a31f40901030624w4501e6f2l19d54a1e5223252c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901030624w4501e6f2l19d54a1e5223252c@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 07:54:34PM +0530, Jaswinder Singh Rajput wrote:
> On Sat, Jan 3, 2009 at 7:15 PM, Willy Tarreau <w@1wt.eu> wrote:
> > On Sat, Jan 03, 2009 at 07:04:57PM +0530, Jaswinder Singh Rajput wrote:
> >> Hello Willy,
> >>
> >> Do you have any plans to add scripts/checkpatch.pl in 2.4 git.
> >
> > Not particularly planned, though I have nothing against including it if
> > some people want to use it.
> >
> 
> Please add it. At least I can use it :-)

OK will do.

> >> Currently, what is the procedure to check patch for 2.4 git.
> >
> > Nowadays, 2.4 patches are so small that one's eyes are enough to check
> > for correctness ;-)
> >
> 
> I ran 2.6 checkpatch.pl on some files and found lot of style problems
> like white spaces and indent.
> After fixing these problems code will be more read-able.
> I have plan to fix these problems on some important files. What you
> think about this.

I don't want to merge pure code cleanup patches, because :
  1) it brings no added value to the final user
  2) there's always a risk of regression

The only exception I accept to make is when I resync a file with 2.6 in
order to ease future patches.

However, I welcome cleanups which come with other changes/fixes, provided
they're not too invasive.

Regards,
Willy

