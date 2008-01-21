Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYAUI5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYAUI5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbYAUI53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:57:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:18617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbYAUI5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:57:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EA/Xj+m4svIu8HBLspmHN2JcxMnl06igGUdDpv9b8/JfAqMIoWvg5PU4cpg4lookaSxGiYmhrYnZd6GYkpLbAyfR+FhlGjkClXmLv6WXWbCrmk0IBfSUbZtl3pEBmNqRLowFV3WNfo8JIRXFYmOYLUbn0p4VpvzUSXdjO0GpbcA=
Date: Mon, 21 Jan 2008 10:03:58 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080121090358.GB1789@ff.dom.local>
References: <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com> <20080118073836.GA1703@ff.dom.local> <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com> <20080118082327.GC1703@ff.dom.local> <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com> <4791C555.9050205@gmail.com> <20080121013021.GB2832@darkstar.te-china.tietoenator.com> <20080121014335.GA3219@darkstar.te-china.tietoenator.com> <20080121083608.GA1789@ff.dom.local> <a8e1da0801210044t5f705f77n8e310878775f7b5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801210044t5f705f77n8e310878775f7b5b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 04:44:36PM +0800, Dave Young wrote:
...
> I applied it in my kernel, built and run without warnings, but it need
> more testing.
> I will be very glad to see the test result about this if you could, thanks.

I'll try this of course, but alas I don't have anything such more
sophisticated to verify this possibility of deeper nesting.

Thanks,
Jarek P.
