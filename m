Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZCQEua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZCQEua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZCQEuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:50:16 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:50200 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZCQEuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:50:15 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries 
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090317042210.GA17533@kroah.com>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp> <20090316180538.GA7069@kroah.com> <7200.1237260402@jrobl> <20090317033747.GA17037@kroah.com> <7974.1237262747@jrobl> <20090317042210.GA17533@kroah.com>
Date: Tue, 17 Mar 2009 13:50:09 +0900
Message-ID: <8683.1237265409@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH:
> > - the abs path of a directory which is a member of a union.
> > - the abs path of a xino file which is a regular file maintained by
> >   aufs.
> 
> And what do people do with this information?  Is it just debugging
> stuff?  If so, please put it in debugfs, not sysfs.

No, they are not debugging stuff.
Users will need to know or confirm the member of union and the xino file
path. To show their abs path is necessary. Initially aufs showed them in
/proc/mounts (and /etc/mtab). But some users met the size limitation of
them since they build a union with many members. And I moved them to
sysfs (one path per a sysfs file).


J. R. Okajima


