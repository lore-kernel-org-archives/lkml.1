Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYIYOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYIYOoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYIYOoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:44:03 -0400
Received: from outbound-mail-121.bluehost.com ([67.222.38.21]:44795 "HELO
	outbound-mail-121.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752192AbYIYOoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:44:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=r5bsmv2WKG7s+fqeh/y5UuMNAOAOSyAlelZR9ZVCEpsVOOv0vaqsXxxXPtb+PjFsVUsEbckaEJRltz9HZTdxM4Y4NoEZCZDjC43dX1Enod9RMTE3H9XeGrumejEYwjeQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak v2
Date: Thu, 25 Sep 2008 07:43:34 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       mark gross <mgross@linux.intel.com>
References: <1222327705-22048-1-git-send-email-yhlu.kernel@gmail.com> <20080925081158.GA30349@elte.hu>
In-Reply-To: <20080925081158.GA30349@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250743.35271.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2008 1:11 am Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > use early_acpi_os_unmap_memory
> >
> > v2: move unmap_memory early...
> >
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> > ---
> >  drivers/pci/dmar.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
>
> since this depends on other x2apic/sparseirq changes in -tip i've
> applied it to tip/irq/sparseirq.
>
> Jesse, any objections?

Nope, but it would be good to get Dave or Mark's ack (Dave owns this code 
now).

Jesse
