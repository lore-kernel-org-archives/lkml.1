Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbXEJPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbXEJPgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXEJPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:36:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57616 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbXEJPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:36:39 -0400
Date: Thu, 10 May 2007 08:17:22 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] driver-core: don't free devt_attr till the device is
	released
Message-ID: <20070510151722.GA22860@kroah.com>
References: <602729.80444.qm@web52910.mail.re2.yahoo.com> <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com> <4641E245.7040603@gmail.com> <20070509154039.GA27681@kroah.com> <46432FFD.1040304@gmail.com> <20070510150501.GA22752@kroah.com> <46433686.6080007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46433686.6080007@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 05:13:10PM +0200, Tejun Heo wrote:
> Greg KH wrote:
> >> Applies well to 2.6.20 and 21.  As sysfs-immediate-disconnect doesn't
> >> seem to be included in 2.6.22, this should be included in linus#master
> >> too (applies well there as well).
> > 
> > As I don't think we should be adding your sysfs rework to 2.6.22 just
> > yet, any objections to me just sending this to Linus for 2.6.22 and
> > waiting on your previous one for when the whole sysfs rework patchset is
> > sent?
> 
> No objection at all.  That actually is exactly my intention.  The
> make-attrs-static patch will conflict with this fix tho.  Just let me
> know when it breaks, I'll post updated one.

If it breaks, I'll fix up the merge issues, don't worry about it :)

Thanks again for taking the time and tracking it down and fixing this.

greg k-h
