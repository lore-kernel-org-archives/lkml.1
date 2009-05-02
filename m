Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZEBONi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZEBONi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZEBONa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:13:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbZEBON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:13:29 -0400
Date: Sat, 2 May 2009 10:13:08 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Helge Deller <deller@gmx.de>
Cc: Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 3/5] parisc: use new macros for .data.init_task.
Message-ID: <20090502141308.GA28342@bombadil.infradead.org>
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu> <1241135719-9286-2-git-send-email-tabbott@mit.edu> <1241135719-9286-3-git-send-email-tabbott@mit.edu> <1241135719-9286-4-git-send-email-tabbott@mit.edu> <49FBD681.9080605@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FBD681.9080605@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 07:13:37AM +0200, Helge Deller wrote:
> I think this patch is wrong, although it is theoretically correct.
> 
> IIRC, gcc on hppa is not able to provide an alignment >= 8k, which is
> why we have done the 16k alignment inside the linker script.
> So, I think this change will prevent the parisc kernel to boot up.
> Needs testing.
> 

I think you're confusing this with the 8-byte maximum alignment from
kmalloc and on-stack that prevents us from just using a 16-byte aligned
word as a lock on pa1.1?

The patch I trimmed from this mail looks correct to me.

regards, Kyle
