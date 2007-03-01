Return-Path: <linux-kernel-owner+w=401wt.eu-S965382AbXCARDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965382AbXCARDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965395AbXCARDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:03:36 -0500
Received: from averell.tiscali.it ([213.205.33.55]:53934 "EHLO
	averell.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965382AbXCARDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:03:35 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 12:03:34 EST
Subject: Re: SMP performance degradation with sysbench
From: Lorenzo Allegrucci <l.allegrucci@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: "\"J.A." =?ISO-8859-1?Q?Magall=F3n=22?= <jamagallon@ono.com>,
       Hiro Yoshioka <hyoshiok@miraclelinux.com>, davej@redhat.com,
       harlan@artselect.com, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, mingo@elte.hu, suparna@in.ibm.com,
       jens.axboe@oracle.com
In-Reply-To: <1172603127.5482.35.camel@odyssey.lan>
References: <20070226223645.GA24174@redhat.com>
	 <98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
	 <45E37EA3.3060101@redhat.com>
	 <20070227.130305.424251739.hyoshiok@miraclelinux.com>
	 <45E3B421.603@redhat.com> <20070227091409.6f3d12f9@werewolf-wl>
	 <45E439E4.5030703@redhat.com>  <1172603127.5482.35.camel@odyssey.lan>
Content-Type: text/plain
Organization: -ENOENT
Date: Thu, 01 Mar 2007 17:57:05 +0100
Message-Id: <1172768226.5419.9.camel@odyssey.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 20:05 +0100, Lorenzo Allegrucci wrote:
> On Tue, 2007-02-27 at 09:02 -0500, Rik van Riel wrote:
> > That still doesn't fix the potential Linux problem that this
> > benchmark identified.
> > 
> > To clarify: I don't care as much about MySQL performance as
> > I care about identifying and fixing this potential bug in
> > Linux.
> 
> Here http://people.freebsd.org/~kris/scaling/mysql.html Kris Kennaway
> talks about a patch for FreeBSD 7 which addresses poor scalability
> of file descriptor locking and that it's responsible for almost all
> of the performance and scaling improvements.

How does Linux scale with many threads contending for file descriptor
lock?
Has anyone tried to run the test with oprofile?


