Return-Path: <linux-kernel-owner+w=401wt.eu-S932670AbXBXBpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbXBXBpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 20:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932738AbXBXBpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 20:45:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbXBXBpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 20:45:11 -0500
Date: Fri, 23 Feb 2007 17:43:37 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation
Message-Id: <20070223174337.60d9ed3f.zaitcev@redhat.com>
In-Reply-To: <20070223081005.GB10055@cvg>
References: <20070219181549.GB10111@cvg>
	<20070222155523.53e649a3.zaitcev@redhat.com>
	<20070223075322.GA10055@cvg>
	<20070222235738.f36e534a.zaitcev@redhat.com>
	<20070223081005.GB10055@cvg>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007 11:10:05 +0300, Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> I may be wrong, but a lot of the kernel code have static pointers
> initialized to NULL with explicit manner... More over I always thought
> that _static_ is not mean _initialized to zero_. I think _static_ is
> just the method to _hide_ variables in the file (as ANSI C describes).
> Am I wrong?

I'm afraid you are wrong here. Static variables are initialized on
zero in C, although I cannot provide you with a relevant quote from
a standard. Just trust me for now, and resubmit the patch without
the first segment... :-)  You're clearly fixing a bug in it.

-- Pete
