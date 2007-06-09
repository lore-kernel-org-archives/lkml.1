Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbXFIFpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbXFIFpw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXFIFpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:45:45 -0400
Received: from bay0-omc3-s33.bay0.hotmail.com ([65.54.246.233]:53030 "EHLO
	bay0-omc3-s33.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbXFIFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:45:44 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 01:44:54 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and
 manipulation,pathname matching
Message-Id: <20070609014454.2f1f2f91.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
	<200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
	<20070608232531.d68de09f.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
	<20070609011022.ac332fc7.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 05:45:43.0921 (UTC) FILETIME=[6BB56610:01C7AA59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 22:38:57 -0700 (PDT)
david@lang.hm wrote:


> so are you suggesting that SELinux would call out to userspace for every 
> file open to get the label for that file?
> 

No, i'm not.  You must already have a kernel function in the current
implementation of AA that decides the proper policy for each path.  Why
not use it  to feed labels into SELinux.

Sean
