Return-Path: <linux-kernel-owner+w=401wt.eu-S1767204AbXDESnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767204AbXDESnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767205AbXDESnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:43:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:21823 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767210AbXDESnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oj7S4LvtwDQvC4EdMtp+Qg78SNft8sFxl1gt6zUMAa4BRm1OAp1wZv4BPkpziTUSs+RWyrMt57DiMSmRcUCOvlsJKzixXIpeipI0bHtF+Y6i7HlPHYl9UZ6n4IQyDAIMhFD3AQ+oMu9tWqyF3OiaGMV22R8ki6F3UMiKgeIVNoA=
Subject: Re: vfb module
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Michael Trimarchi <trimarchi@gandalf.sssup.it>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4614B388.7050002@gandalf.sssup.it>
References: <4614B388.7050002@gandalf.sssup.it>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 02:42:50 +0800
Message-Id: <1175798570.5549.1.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 10:30 +0200, Michael Trimarchi wrote:
> Hi,
> I changed a little bit the vfb module to be used as a frame buffer in 
> memory. I would like to use the mmap over the virtual framebuffer. I 
> added a few line:
> I allocated the buffer using
> videomemory=(void *)__get_free_pages(GFP_KERNEL, 
> get_order(PAGE_ALIGN(videomemorysize)));
> 
> and fixed the framebuffer info structure:
> 
> vfb_fix.smem_start = virt_to_phys(videomemory);
> vfb_fix.smem_len = videomemorysize;
> 
> What is the virtual frame buffer meant for?

For testing, and some uses it as a skeleton for another driver.

Tony


