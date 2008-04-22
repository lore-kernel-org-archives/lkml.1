Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbYDVNay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbYDVNay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbYDVNap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:30:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbYDVNan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:30:43 -0400
Date: Tue, 22 Apr 2008 06:28:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "werner" <werner@copaya.yi.org>
Cc: linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: EDD problem -- regression -- crash on booting by probing EDD
Message-Id: <20080422062840.195b4d3d.akpm@linux-foundation.org>
In-Reply-To: <1208730812.6879@copaya.yi.org>
References: <1208730812.6879@copaya.yi.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 20 Apr 2008 19:33:32 -0300 (GFT) "werner" <werner@copaya.yi.org> wrote:
> There is a regression in 2.6.25.

Rafael bcc'ed.

>   Booting stops with: Probing EDD (edd=off to disable) message.
> 
> It dont work the kernel boot parameter edd=off .  With pci=off the computer continues to boot, but later it dont find hard disks etc.

Tim and Matt cc'ed.

> Thats happening on 2.6.25   definitive, but was verified to go back until 2.6.24-rc6-git8, but it wasnt yet at 2.6.24-rc6-git2 which worked correctly.
> 

hm, that's a nice narrow window.  Unfortunately for the next few days I
can't personally get in and find out what we changed during it.

It would be useful if you could add `initcall_debug' to your kernel
boot command line, please. That will help us to confirm that the
bug is indeed in edd_init(), rather than in something which was
called later on.

Thanks.
