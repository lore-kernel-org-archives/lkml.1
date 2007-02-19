Return-Path: <linux-kernel-owner+w=401wt.eu-S965099AbXBSWLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099AbXBSWLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965101AbXBSWLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:11:40 -0500
Received: from main.gmane.org ([80.91.229.2]:34584 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965099AbXBSWLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:11:38 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sam Hokin <sam@ims.net>
Subject: Re: I2O block driver broken in kernel 2.6.19?
Date: Mon, 19 Feb 2007 21:22:50 +0000 (UTC)
Message-ID: <loom.20070219T222117-837@post.gmane.org>
References: <45D8E102.6090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 66.170.6.14 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Fedora/1.5.0.9-1.fc6 Firefox/1.5.0.9 pango-text)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert <at> redhat.com> writes:

> 
> Fedora is getting a bunch of bug reports about the I2O block
> driver not working in 2.6.19 kernels.
> 
> Everything looks like it loads OK, but no block IO can be
> done, not even reading the partition table:

...[snip]

This is reproduced on my SMP 2.6.19 machine.  Under 2.6.18 the i2o drive is
fine; under the latest 2.6.19 kernel, it throws errors at startup as reported in
this thread.  i2o firmware version is v001.62 2002/11/06.

