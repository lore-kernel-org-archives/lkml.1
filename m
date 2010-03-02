Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0CBC24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 21:28:56 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:50849 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0CBC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 21:28:55 -0500
From: James Cloos <cloos@jhcloos.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in  git tree
In-Reply-To: <20100302012055.GK6758@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Mon, 1 Mar 2010 17:20:55 -0800")
References: <20100301042249.GA12289@linux.vnet.ibm.com>
	<alpine.LFD.2.00.1003010812410.3616@localhost.localdomain>
	<20100301164800.GC6758@linux.vnet.ibm.com>
	<m3r5o34vnp.fsf@lugabout.jhcloos.org>
	<20100302012055.GK6758@linux.vnet.ibm.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 01 Mar 2010 20:53:19 -0500
Message-ID: <m3d3zn4hg8.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Hashcash: 1:30:100302:paulmck@linux.vnet.ibm.com::ori+00RMt9OvIouF:0000000000000000000000000000000000Utpry
X-Hashcash: 1:30:100302:torvalds@linux-foundation.org::F8DtrbxGRHWNE0K9:0000000000000000000000000000000vjR4y
X-Hashcash: 1:30:100302:linux-kernel@vger.kernel.org::fjTouoEtTZhQKwZa:00000000000000000000000000000000b3uiK
X-Hashcash: 1:30:100302:zippel@linux-m68k.org::ErXMJrVK3fx8MMP3:000000000000000000000000000000000000000Waf3p
X-Hashcash: 1:30:100302:mingo@elte.hu::raoDPR2urVGGVc+M:000F/xqJ
X-Hashcash: 1:30:100302:akpm@linux-foundation.org::LVq8FfVswqgtMP83:00000000000000000000000000000000000YmaZ/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Paul" == Paul E McKenney <paulmck@linux.vnet.ibm.com> writes:

Paul> Agreed!  The "-dirty" modifier for the case of changes not yet
Paul> checked into git looks especially helpful.

JimC> Except that the script calls »git update-index --refresh --unmerged«
JimC> and »git diff-index --name-only HEAD«, both of which are painfully
JimC> slow and resource intensive.

JimC> I'd hate to have that run every time I make a kernel.

Paul> Good point...  Should we have an environment variable that controls
Paul> this behavior?

I wouldn't mind the intial idea: just the abbreviated top of three hash.

I was, next, going to write that CONFIG_LOCALVERSION_AUTO already exists
for that, but LOCALVERSION_AUTO calls scripts/setlocalversion these days
and that is what I'd prefer to avoid.  [SIGH]

Shows how long it has been since I last used it.  I stopped using it
when I was maintaining my .config in git.  Now I maintain .config in a
separate git repo, for the express purpose of avoiding a merge (rather
than a fast forward) when I run git pull.  Something that a local edit
of scripts/setlocalversion will, of course, prevent.

Anyone up for a CONFIG_LOCALVERSION_AUTO_DO_NOT_BOTHER_WITH_DIRTY? ☺

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
