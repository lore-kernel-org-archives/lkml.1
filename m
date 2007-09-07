Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXIGMuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXIGMuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 08:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965305AbXIGMuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 08:50:06 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:41633 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965188AbXIGMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 08:50:05 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union Mount: Readdir approaches 
To: Al Boldi <a1426z@gawab.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
In-Reply-To: <200709071454.32451.a1426z@gawab.com>
References: <20070907054618.GD1692@in.ibm.com> <E1ITYJK-0000xP-8h@jroun> <200709071454.32451.a1426z@gawab.com>
Date: Fri, 07 Sep 2007 21:49:25 +0900
Message-Id: <E1ITdH3-0000sb-N4@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Al Boldi:
> > If you are interested in this approach, please refer to
> > http://aufs.sf.net. It is working and used by several people.
> 
> Any chance you can post a patch against 2.6.22?

Unfortunately there are many reasons to keep me away from sending a
patch.
- it is large (48 source files).
- it supports linux-2.6.16 and later, and uses
	#if ... LINUX_VERSION_CODE ...
  condition a lot. I want to keep handling them as long as possible
  since some users use it.
- there are sereral codes I want to rewrite cleanly or well-behaved.
- and other reasons.

But if you really want to read or try it, you can get all source files
from sourceforge. Read http://aufs.sf.net and try,
$ cvs -d:pserver:anonymous@aufs.cvs.sourceforge.net:/cvsroot/aufs login
(CVS password is empty)
$ cvs -z3 -d:pserver:anonymous@aufs.cvs.sourceforge.net:/cvsroot/aufs co aufs


Regards,
Junjiro Okajima
