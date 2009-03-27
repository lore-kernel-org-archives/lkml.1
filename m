Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZC0TGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZC0TGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZC0TFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:05:52 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:49312 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZC0TFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:05:51 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49CD235E.7030404@lwfinger.net>
Date: Fri, 27 Mar 2009 14:05:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Li Zefan <lizf@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Possible IRQ lock inversion from 2.6.29-Linus-03321-gbe0ea69
 (2.6.29-git)
References: <49CC5F15.4020404@lwfinger.net> <200903271354.45480.bzolnier@gmail.com> <20090327120623.3056c795@bike.lwn.net>
In-Reply-To: <20090327120623.3056c795@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> 
> We could do that.  When I made the change I'd verified that there were
> no users in IRQ context, and I couldn't really see why there should
> be.  I'd rather avoid adding all those IRQ disables if I can avoid it.
> 
> How about, instead, just reversing the order of lock acquisition in
> fasync_helper()?  That would increase the hold time for f_lock, but I
> have a hard time seeing that being a real problem.  I'm running with
> the following now; all seems well.  I'll send it up in a bit if nobody
> gripes.

The patch gets rid of the warning for me.

Larry
