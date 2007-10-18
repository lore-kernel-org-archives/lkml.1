Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbXJRCSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbXJRCSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXJRCSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:18:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXJRCSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:18:40 -0400
Date: Wed, 17 Oct 2007 19:18:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Fricaccia <thomas_fricacci@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: LSM conversion to static interface
In-Reply-To: <167451.96128.qm@web38607.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Thomas Fricaccia wrote:
> 
> But then I noticed that, while the LSM would remain in existence, it was 
> being closed to out-of-tree security frameworks.  Yikes!  Since then, 
> I've been following the rush to put SMACK, TOMOYO and AppArmor 
> "in-tree".

Yeah, it did come up. Andrew, when he sent it on to me, said that the SuSE 
people were ok with it (AppArmor), but I'm with you - I applied it, but 
I'm also perfectly willing to unapply it if there actually are valid 
out-of-tree users that people push for not merging.

So Í don't think this is settled in any way - please keep discussing, and 
bringing it up. I'm definitely not in the camp that thinks that LSM needs 
to be "controlled", but on the other hand, I'm also not going to undo that 
commit unless there are good real arguments for undoing it (not just 
theoretical ones).

For example, I do kind of see the point that a "real" security model might 
want to be compiled-in, and not something you override from a module. Of 
course, I'm personally trying to not use any modules at all, so I'm just 
odd and contrary, so whatever..

Real usage scenarios with LSM modules, please speak up!

		Linus
