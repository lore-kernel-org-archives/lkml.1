Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXD1O2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXD1O2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXD1O2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:28:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1121 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753873AbXD1O2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:28:43 -0400
Date: Sat, 28 Apr 2007 10:28:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: gregkh@suse.de, <dmitry.torokhov@gmail.com>, <cornelia.huck@de.ibm.com>,
       <oneukum@suse.de>, <rpurdie@rpsys.net>, <maneesh@in.ibm.com>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] sysfs: sysfs rework, take #2
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704281026400.29437-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Tejun Heo wrote:

> Subject: [PATCHSET] sysfs: sysfs rework, take #2
> 
> Hello, all.
> 
> This is respin of syswork rework patchset in gregkh patch series.
> Changes are...

...

> All the known regrssions are fixed.  I think I've got all the
> attr->owner but haven't verified with cross compiling yet, just
> allyesconfig on x86-64 and i386.  I'll try to setup some cross compile
> environments tomorrow and follow up if I can find more fallouts.

What have you done about the problem of device nodes getting unregistered
while the corresponding sysfs directory is non-empty, say with child
device directories still present?

Alan Stern

