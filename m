Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYH2Kyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYH2Kyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYH2Ky0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:54:26 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:8416 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYH2KyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:54:25 -0400
Date: 29 Aug 2008 12:54:20 +0200
From: kovlensky@interia.pl
Subject: Re: mounting windows shares with path exactly like on windows
To: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-ORIGINATE-IP: 195.224.154.166
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20080829105420.E10967E8036@f17.poczta.interia.pl>
X-EMID: 96e40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

Thank you for massive support. First - all of you miss one important issue - slash/backlash conversion, when transferring path from Linux to Windows and back. Second - that's corporate with tens of people relying on these systems running. Answering questions about application - that's big engineering one, with port existing on many os'es. Objects, which are created there, point to physical files on disk. It's like symlink. One symlink per object. As these symlinks are simply single paths to file I find it impossible to develop any method of having a link working on both Linux and Windows. Also writing anything on my own won't work - I know that it can be done with LD_PRELOAD for example, but try convincing big corporation that their development-critical environment can safely rely on your custom piece of code...

Many suggestions were very helpful, but, unfortunately, looks like no real linux world approved solution exisits.

Regards,

Zdenek


Alan Jenkins napisa³(a):
> kovlensky@interia.pl wrote:
> 
> > I&#039;m sorry to be slightly off topic, when it comes to this list, but I
> have
> > no clue where to look for that and I think it can be doe on kernel
> level
> > only.
> >
> > In short - I&#039;ve got bunch of applications running both on windows and
> > linux and these applications exchange links to files mounted on both
> > sides. The problem is that these paths are different, i.e. like
> > D:/dir/file on windows and /mountpoint/dir/file on Linux. What I need
> is
> > unifying them. So my idea is to have path translator on anything on
> kernel
> > level, which will make Linux open call to D:/dir/file on Linux work and
> > open /mountpoint/dir/file. Was anything close to that ever incorporated
> in
> > kernel?
> 
> Um, no.
> 
> More likely solutions are ptrace (intercept system calls using debugging
> interface) or similar LD_PRELOAD magic (see fakeroot for an example).
> 
> > Applications are, as usual, closed source, and support for them, also
> as
> > usual, answers "won&#039;t be fixed, switch to Windows, please". Very
> helpful.
> >
> > Any other ideas of solving this problem are also warmly welcomed. Also
> on
> > windows side.
> 
> I thought modern windows supported unix-like mounts, a bit like the old
> SUBST.EXE in dos.  So you could then mount all other drive letters as
> subdirectories on the main drive.  Don&#039;t ask me how to do it though :-).
> 
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



----------------------------------------------------------------------
Tani telefon!
Sprawdz >>> http://link.interia.pl/f1ef5 


