Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbXKKWp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbXKKWp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbXKKWpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:45:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbXKKWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:45:49 -0500
Date: Sun, 11 Nov 2007 14:45:23 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Piel <Eric.Piel@lifl.fr>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: Kernel panic at boot with ondemand governor as default
 (2.6.24-rc2)
Message-ID: <20071111144523.14164575@laptopd505.fenrus.org>
In-Reply-To: <4737539F.2070401@lifl.fr>
References: <4737539F.2070401@lifl.fr>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007 20:10:23 +0100
Eric Piel <Eric.Piel@lifl.fr> wrote:

> Hello,
> 
> I've tried kernel 2.6.24-rc2 and I have a problem with the new option 
> for setting up the cpufreq ondemand governor as default: a kernel
> panic happens early at boot time. If I boot first with performance
> governor and later change to ondemand, everything is fine (as usual).
> 
> This seems related to the delayed_workqueue. The kernel panic message 
> finishes by:
> EIP: [<c012aa60>] wq_per_cpu+0x0/0x10 SS:ESP 0068:c191be58
> Kernel panic - not syncing: Attempted to kill init!
> 
> A picture of the whole message is available here:
> http://pieleric.free.fr/unorder/1162-ondemand-panic.jpg
> 
> My computer is a x86 using speedstep-ich, and you can find the full 
> .config leading to the panic attached.
> 
> Does anyone has any idea was it going wrong?
> Thanks,
> Eric
> 
> PS: I haven't tried 2.6.24-rc1.
> 

has ondemand ever worked for you?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
