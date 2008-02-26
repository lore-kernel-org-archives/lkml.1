Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbYBZPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbYBZPhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbYBZPhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:37:23 -0500
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:55092
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726AbYBZPhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:37:22 -0500
X-Authority-Analysis: v=1.0 c=1 a=TEGKNp2qDdgA:10 a=_K75SHx9ETXD_wMSpTAA:9
 a=ICtLINas2gqvPAC8MuBJSXgkC0AA:4 a=uv1ck3d6JtEA:10
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, elendil@planet.nl,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz>
References: <1203123219.6176.36.camel@popeye>
	 <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
	 <1203163503.6124.5.camel@popeye>
	 <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
	 <1203221372.6124.29.camel@popeye>
	 <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz>
	 <1203587101.27355.4.camel@popeye>
	 <20080226145832.GA1289@csclub.uwaterloo.ca>
	 <Pine.LNX.4.64.0802261602030.30955@jikos.suse.cz>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 09:37:36 -0600
Message-Id: <1204040256.12792.58.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri - 

For what it is worth, and understand that it is hard to prove a
negitive, on slack moments over the weekend I repeatedly booted my
system into single user (console) mode using a kernel with
CONFIG_GROUP_SCHED set to yes.

To date I have NOT been able to recreate the repeating key issue outside
of X.

Chris


On Tue, 2008-02-26 at 16:05 +0100, Jiri Kosina wrote:
> On Tue, 26 Feb 2008, Lennart Sorensen wrote:
> 
> > Hmm, I have been seeing repeated keys a lot under X on my athlon 700, 
> > but mainly when I have firefox running (which is of course quite a load 
> > on the poor old thing).  This has been going on for probably the last 
> > year or so.  I thought it was just the machine getting weird, although 
> > whenever it wasn't running firefox or other memory/cpu heavy loads it 
> > seemed fine.
> 
> This could be caused by the fact that as far as I know, X are not using 
> kernel-autorepeat, but they are handling it themselves, right? So if their 
> sense of time (probably due to some change of kernel timekeeping) gets 
> wrong, the autorepeat in X might also get wrong.
> 
> It would be nice to know if when you hit the situation when autorepeat 
> goes strange in X, if it is still OK in console.
> 

