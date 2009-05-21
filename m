Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZEUOqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZEUOqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZEUOqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:46:32 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:33368 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZEUOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:46:31 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Date: Thu, 21 May 2009 08:46:17 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-server; KDE/4.2.2; x86_64; ; )
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
References: <49ED22EC.2040204@kernel.org> <200905081640.12677.bjorn.helgaas@hp.com> <20090520164910.6939b92b@jbarnes-g45>
In-Reply-To: <20090520164910.6939b92b@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905210846.18292.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 May 2009 5:49:10 pm Jesse Barnes wrote:
> On Fri, 8 May 2009 16:40:10 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > Did anything happen with this?
> > 
> > The longer we wait to make "use_crs" the default, the harder it
> > will be, so I'd like to push ahead.
> 
> Here's a patch to make CRS the default.  If it looks ok I can push it
> into my linux-next branch.  I'm all for using reliable data from the
> BIOS.  I guess we'll find out fairly quickly if this stuff isn't...

Thanks for following up on this, Jesse.  It was on my to-do list for
yesterday, but I didn't get to it.

Yinghai mentioned a specific box where we might have trouble, but we
never got enough details to really debug it.  So I think we might as
well give it a shot and fine-tune it as we need to.

Bjorn
