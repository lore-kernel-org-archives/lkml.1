Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXJaGpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXJaGpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbXJaGpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:45:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXJaGpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:45:24 -0400
Date: Tue, 30 Oct 2007 23:45:39 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       zaitcev@redhat.com
Subject: Re: Huawei E220 and usb storage
Message-Id: <20071030234539.aecca9e8.zaitcev@redhat.com>
In-Reply-To: <20071031062356.GI11722@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
	<20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
	<20071030204720.GI8479@gamma.logic.tuwien.ac.at>
	<47279EF7.3040406@redhat.com>
	<20071030212213.GA13410@gamma.logic.tuwien.ac.at>
	<20071030152816.f2e8dd7c.zaitcev@redhat.com>
	<20071031061552.GH11722@gamma.logic.tuwien.ac.at>
	<20071031062356.GI11722@gamma.logic.tuwien.ac.at>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 07:23:56 +0100, Norbert Preining <preining@logic.at> wrote:

> Hmm, in addition I added a
> 	printk(KERN_ERR "ENTERING usb_stor_huawei_e220_init!\n");
> at the beginning of the function but it never showed up in my log files.
> So it seems that the UNUSUAL_DEV entry does not match.

This doesn't seem to be possible, considering the /proc/bus/usb/devices
that you posted. I would rather suspect that you forgot to perform
some step in your kernel installation, and end using a stale
usb-storage module.

-- Pete
