Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXDEJaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXDEJaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXDEJaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:30:12 -0400
Received: from ms01.sssup.it ([193.205.80.99]:42576 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965584AbXDEJaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:30:05 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 05:30:04 EDT
Message-ID: <4614B388.7050002@gandalf.sssup.it>
Date: Thu, 05 Apr 2007 10:30:00 +0200
From: Michael Trimarchi <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: vfb module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I changed a little bit the vfb module to be used as a frame buffer in 
memory. I would like to use the mmap over the virtual framebuffer. I 
added a few line:
I allocated the buffer using
videomemory=(void *)__get_free_pages(GFP_KERNEL, 
get_order(PAGE_ALIGN(videomemorysize)));

and fixed the framebuffer info structure:

vfb_fix.smem_start = virt_to_phys(videomemory);
vfb_fix.smem_len = videomemorysize;

What is the virtual frame buffer meant for?

Regards Michael

