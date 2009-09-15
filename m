Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZIOGow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZIOGow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZIOGoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:44:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34549 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbZIOGoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:44:46 -0400
To: torvalds@linux-foundation.org
CC: Joel.Becker@oracle.com, mfasheh@suse.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
In-reply-to: <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	(message from Linus Torvalds on Mon, 14 Sep 2009 14:32:36 -0700 (PDT))
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
References: <20090911200458.GA15416@mail.oracle.com> <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
Message-Id: <E1MnRmG-0005j1-Bs@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Sep 2009 08:44:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Linus Torvalds wrote:
> Are we going to add 'freflink[at]()' at some point?

We already have an interface for "freflink()" called splice().  Splice
has all the arguments needed to implement refcounted data copies and
more.

Yes, splice's name implies more of a "piecing data together" type of
operation, but we can look at reflink() or copyfile() as just "splice
one big piece from here to there".

Thanks,
Miklos
