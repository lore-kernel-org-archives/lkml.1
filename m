Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717Ab0AYSuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0AYSuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702Ab0AYSuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:50:04 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:37043 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751323Ab0AYSuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:50:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Z5KGyb7zBULv1W7HnDxDtL79CA/5rr1znt6bD0/691aPbMtaiCU8HjwhGIvL+xZW8wzfClFyHIQBi3SZ+C1n6xfzzJgf/bBEsG9QG6S604WVzwtIrypAwTr85f2/+Q2d;
Date: Mon, 25 Jan 2010 10:49:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86/pci: use resource_size_t in update_res -v2
Message-ID: <20100125104951.39e0fa40@jbarnes-piketon>
In-Reply-To: <4B59059A.7090206@kernel.org>
References: <4B2BE063.4040704@kernel.org>
	<4B2BE181.5090406@kernel.org>
	<20100115114956.6207cfa4@jbarnes-piketon>
	<4B50DC35.4080502@kernel.org>
	<20100115133932.5d622fdc@jbarnes-piketon>
	<4B59059A.7090206@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 17:55:38 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 01/15/2010 01:39 PM, Jesse Barnes wrote:
> > On Fri, 15 Jan 2010 13:20:53 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> On 01/15/2010 11:49 AM, Jesse Barnes wrote:
> >>> On Fri, 18 Dec 2009 12:09:37 -0800
> >>> Yinghai Lu <yinghai@kernel.org> wrote:
> >>>
> >>>>
> >>>>
> >>>> prepare to enable 32bit intel and amd bus
> >>>>
> >>>> v2: change __init to __devinit
> >>>>
> >>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>>> ---
> >>>
> >>> Applied 2-3 to my linux-next branch, thanks.  (1 was already
> >>> applied to fix Jens' problem over the holidays, thanks hpa).
> >>>
> >>
> >> will find out good apply sequence....
> > 
> > Pushing the ones for 32 bit bus driver support through -tip is fine
> > with me, you can add my Acked-by.
> 
> please drop 2 and 3 from pci/linux-next tree. we need to make them go
> through tip/x86 tree with range related seperating code.
> 
> http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;h=f84fe8aef6e4b23ab58175a15dd12c197c993f81
> http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;h=693f084f82a38fc1b01e3b05664a6fe014a3488a

Ok, dropped.

-- 
Jesse Barnes, Intel Open Source Technology Center
