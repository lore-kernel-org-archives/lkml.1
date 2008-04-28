Return-Path: <linux-kernel-owner+w=401wt.eu-S1765961AbYD1KQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765961AbYD1KQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYD1KP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:15:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34320 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbYD1KP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:15:57 -0400
To: miklos@szeredi.hu
CC: viro@ZenIV.linux.org.uk, miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1Jp47x-0004MY-1W@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Thu, 24 Apr 2008 18:16:53 +0200)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk> <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu> <20080424152129.GK15214@ZenIV.linux.org.uk> <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu> <20080424155954.GM15214@ZenIV.linux.org.uk> <E1Jp47x-0004MY-1W@pomaz-ex.szeredi.hu>
Message-Id: <E1JqQOT-0004IY-7E@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Apr 2008 12:15:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > let alone removing the interface that doesn't require checks to be
> > > > vfsmount-based for all users.
> > > 
> > > What users?  There are paractically _no_ other users.  The ones that
> > > there are (like reiserfs) should not be using them, and there are
> > > already some patches cleaning that mess up.
> > 
> > OK, explain me, in small words, WTF should something that wants to do
> > operations on filesystem tree have a vfsmount.  Slowly.  And "r/o
> > bind loses value if it can be bypassed" is a hogwash - fs methods are
> > still there, so it *can* be bypassed just fine, thank you very much.
> 
> And we know what to do with such users.

Which begs the question: why is ecryptfs doing that with the xattr
methods?  Does it need to bypass the permission checks?  Seems very
fishy to me.

Mike?

Miklos
