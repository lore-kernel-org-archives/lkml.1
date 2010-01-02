Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547Ab0ABGDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0ABGDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 01:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533Ab0ABGDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 01:03:01 -0500
Received: from kroah.org ([198.145.64.141]:57948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0ABGDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 01:03:00 -0500
Date: Fri, 1 Jan 2010 21:59:47 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sysfs: Cache the last sysfs_dirent to improve readdir
	scalability v2
Message-ID: <20100102055947.GA3428@kroah.com>
References: <20091228092712.AA8C.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain> <m11victac1.fsf@fess.ebiederm.org> <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain> <m1fx6rtu31.fsf@fess.ebiederm.org> <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain> <m11viaexlj.fsf_-_@fess.ebiederm.org> <alpine.LFD.2.00.1001011047580.3630@localhost.localdomain> <m1y6kh30pi.fsf_-_@fess.ebiederm.org> <alpine.LFD.2.00.1001011501340.3630@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001011501340.3630@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 03:10:49PM -0800, Linus Torvalds wrote:
> 
> So I guess that's an "Ack", although I'd prefer it to get some more 
> testing and perhaps go through Greg's tree as sysfs patches usually go.
> 
> And by "testing" I mean both the "yes, this second version also breaks the 
> lockdep chain and avoids the warning", but also some kind of actual 
> testing of /sysfs itself. If there is any.

I'll queue this up in my tree on Monday to get it some testing.

thanks,

greg k-h
