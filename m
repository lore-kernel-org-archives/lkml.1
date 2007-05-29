Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbXE2Wxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbXE2Wxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbXE2WxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:53:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:59119 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbXE2WxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:53:19 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Work around Dell E520 BIOS reboot bug.
Date: Wed, 30 May 2007 00:52:58 +0200
User-Agent: KMail/1.9.1
Cc: Matt Domsch <Matt_Domsch@dell.com>, Tim Gardner <rtg@tpi.com>,
       linux-kernel@vger.kernel.org, tim.gardner@ubuntu.com, stable@kernel.org
References: <20070523191244.50078196AA1@rtg.theglobal.net> <20070526025809.GA23351@lists.us.dell.com> <20070529153331.7b643698.akpm@linux-foundation.org>
In-Reply-To: <20070529153331.7b643698.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300052.59212.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007 00:33, Andrew Morton wrote:
> On Fri, 25 May 2007 21:58:09 -0500
>
> Matt Domsch <Matt_Domsch@dell.com> wrote:
> > On Wed, May 23, 2007 at 01:12:44PM -0600, Tim Gardner wrote:
> > > From: Tim Gardner <tim.gardner@ubuntu.com>
> > > Subject: [PATCH] Work around Dell E520 BIOS reboot bug.
> > >
> > > Force Dell E520 to use the BIOS to shutdown/reboot.
> > >
> > > Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
> >
> > Acked-by: Matt Domsch <Matt_Domsch@dell.com>
> >
> > Thanks Tim for submitting this.
>
> Do you think this is also required in 2.6.21.x?

People can always set the boot option. It hardly seems like a critical issue
needing a backport.

> Andi: ack for 2.6.22 inclusion?

Ok. 

At some point we'll likely need to change the default anyways; the 
keyboard controller method seems to become flakier and flakier.
I was actually thinking about using ACPI reset instead though.

-Andi
