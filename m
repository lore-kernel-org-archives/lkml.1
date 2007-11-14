Return-Path: <linux-kernel-owner+w=401wt.eu-S1764148AbXKNBG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764148AbXKNBG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762227AbXKNBGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:06:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:46585 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761759AbXKNBGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:06:08 -0500
Date: Tue, 13 Nov 2007 17:05:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Eric Schoeller <eric.schoeller@colorado.edu>, linux-kernel@vger.kernel.org
Subject: Re: Enabling Magic SysRq Key on boot before INIT
Message-Id: <20071113170529.5d19bedf.randy.dunlap@oracle.com>
In-Reply-To: <473A476D.2000700@redhat.com>
References: <473A07E4.3050004@colorado.edu>
	<473A476D.2000700@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 19:55:09 -0500 Chuck Ebbert wrote:

> On 11/13/2007 03:24 PM, Eric Schoeller wrote:
> > Hello,
> > 
> > I would like to enable the Magic SysRq key immediately when the linux
> > kernel starts to boot, not when INIT begins. So, I am familiar with the
> > sysctl command and /etc/sysctl.conf - but I'd like to modify these types
> > of kernel variables earlier in the boot process. I thought that I could,
> > perhaps, pass an argument to my "kernel" line in my bootloader (grub)
> > configuration, but I have not been able to figure that out.
> > 
> 
> sysrq_always_enabled

I thought that Eric was asking if it was possible to alter sysctls
by adding boot command line arguments.. if he was, then the answer
is no, it's not (in general).

---
~Randy
