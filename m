Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbXG2LoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbXG2LoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 07:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbXG2Ln5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 07:43:57 -0400
Received: from main.gmane.org ([80.91.229.2]:56848 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761479AbXG2Ln4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 07:43:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: Problems with reading DVD using 2.6.21.5
Date: Sun, 29 Jul 2007 13:48:40 +0200
Message-ID: <f8huhd$5ia$1@sea.gmane.org>
References: <fa.vjnUHp6KnLRFG9J2YsYgbtTFq/w@ifi.uio.no> <fa.KUYdQE3sQ4aqYGIgVcGT0tK2bSE@ifi.uio.no> <fa.7w3KoCPMvb0KLfn2mDV9W6PWVrs@ifi.uio.no> <fa.cnztXRn3FAFy2ASRJ66hzuGIJeE@ifi.uio.no> <46AB6ED2.9050509@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e4419c.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.5) Gecko/20070723 FirefoxSucks/9 SeaMonkey/1.1.3
In-Reply-To: <46AB6ED2.9050509@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> It's not entirely clear to me whether the kernel is doing any retries or 
> not. It likely should be, but somebody more familiar with the block 
> layer would likely have to answer whether it will be or not..

Would be pretty great to get answer of someone, who knows if the kernel 
retries on errors.

As remounting fixes the problem, I think it doesn't have to do anything 
with the IDE driver, right? The device node should always be connected 
with the physical device, even if unmount. So the "problem" seems to be 
in the part, which converts "device node" to "readable filesystem" by 
mounting the device node to mount point (ISO 9660 driver?). Seems like 
this part gets restarted by remounting.

So the question is: What exactly will this "ISO 9660 driver" do, if 
there is a read error? Will it mark this "failed byte" as "unreadable" 
and will never try again, or will it try again for at least one ore more 
times?

> Certainly if we are already retrying and the drive keeps saying "no seek 
> complete" there's not much the kernel can do about it..

Thats, of course, true, but it would be pretty interesting to know, if 
the kernel does retrying...

Thanks in advance

CU

Manuel

