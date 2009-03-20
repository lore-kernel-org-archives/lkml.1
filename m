Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbZCTD75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbZCTD75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZCTD7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:59:46 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:63057 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbZCTD7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:59:45 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs 
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090320030608.GA2638@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl> <20090320030608.GA2638@kroah.com>
Date: Fri, 20 Mar 2009 12:59:41 +0900
Message-ID: <5142.1237521581@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH:
> > Greg KH:
> > > Really?  Try leaving them out for now and see if anyone notices :)
> > 
> > Ok, then I will move them to debugfs.
> > Does the rule "one value per file" applied to debugfs too?
> 
> The only rule that debugfs has is:
> 	debugfs has no rules!

To make sure, how do you think this change?

(current)
/sys/fs/aufs/si_<id>/
+ br0 ... brN
+ xi0 ... xiN
+ xi_path
+ xib
+ xigen

(future)
/sys/fs/aufs/si_<id>/
+ br0 ... brN
+ xi_path

/debug/aufs/si_<id>/
+ xi0 ... xiN
+ xib
+ xigen
xiN and xib may be consolidated into a single file.


J. R. Okajima
