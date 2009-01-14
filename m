Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZANBF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZANBF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZANBFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:05:18 -0500
Received: from kroah.org ([198.145.64.141]:60905 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752897AbZANBFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:05:17 -0500
Date: Tue, 13 Jan 2009 17:02:23 -0800
From: Greg KH <greg@kroah.com>
To: San Mehat <san@android.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brian Swetland <swetland@google.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org
Subject: lowmemory android driver not needed?
Message-ID: <20090114010223.GA21380@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi San,

Alan Cox pointed me at the /proc/<pid>/oom_adj file that controls the
oom-killer score for any process as being more than sufficent to control
the oom killer.

This makes me wonder why you wrote the android lowmemlorykiller driver?

What is that driver for that is not already present in the existing
oom_* values for every process?

thanks,

greg k-h
