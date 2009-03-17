Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbZCQM4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbZCQM4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZCQM4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:56:30 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:63891 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZCQM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:56:28 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries 
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20090317103923.GA4630@ioremap.net>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp> <20090316180538.GA7069@kroah.com> <7200.1237260402@jrobl> <20090317033747.GA17037@kroah.com> <7974.1237262747@jrobl> <20090317103923.GA4630@ioremap.net>
Date: Tue, 17 Mar 2009 21:56:11 +0900
Message-ID: <13217.1237294571@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Evgeniy Polyakov:
> On Tue, Mar 17, 2009 at 01:05:47PM +0900, hooanon05@yahoo.co.jp (hooanon05@yahoo.co.jp) wrote:
> > Is the limit of PATH_MAX applied to the absolute path too?
> 
> No, only path used in the given operation (related or absolute) is
> limited. If related path is converted into the absolute just for the
> purpose of dump and not to be used in some syscall, it can have any
> length, so you may need to rethink which pathes are presented in sysfs
> and what should be moved outside.

As a result, current code is implemented.
- aufs entries under sysfs print the absolute path.
- sets limit (PAGE_SIZE) to its length.
- and I think it is enough.

Theoretically, every entries under procfs (or sysfs?) which contains the
absolute path have this problem.


J. R. Okajima
