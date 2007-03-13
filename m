Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbXCMUzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbXCMUzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXCMUzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:55:42 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58115 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbXCMUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:55:35 -0400
X-AuditID: d80ac287-9f7d7bb000000de9-c6-45f70fc75901 
Date: Tue, 13 Mar 2007 20:55:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Alan Stern <stern@rowland.harvard.edu>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       gregkh@suse.de, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <Pine.LNX.4.44L0.0703131604160.7744-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0703132052560.24739@blonde.wat.veritas.com>
References: <Pine.LNX.4.44L0.0703131604160.7744-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 13 Mar 2007 20:55:34.0673 (UTC) FILETIME=[F1FB1810:01C765B1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Alan Stern wrote:
> 
> On the other hand, a quick survey of the kernel source shows that
> DEVICE_ATTR is used over 1500 times.  Auditing all of them is not a job
> for the faint-of-heart!

Indeed, and faint-hearted Hugh wasn't intending to do so: but
stout-hearted Alan will need to, won't he, before his patch can go in?
