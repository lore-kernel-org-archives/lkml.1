Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYEWPbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYEWPbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYEWPav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:30:51 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:33975 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752231AbYEWPau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:30:50 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] x86: early dump pci conf space v2
Date: Fri, 23 May 2008 08:30:28 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <200805221435.11734.yhlu.kernel@gmail.com> <20080523053822.GA28835@colo.lackof.org>
In-Reply-To: <20080523053822.GA28835@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805230830.28699.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 22, 2008 10:38 pm Grant Grundler wrote:
> On Thu, May 22, 2008 at 02:35:11PM -0700, Yinghai Lu wrote:
> > so we can printout pci config before kernel touch it
> >
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Yinghai,
> No offense, but my first thought was this is debug code that should be
> maintained outside the kernel.org tree. It will rarely get used.
> Just want people to think about this before saying "great, add it!"
>
> (And this isn't a stab at Jesse since I think he's doing a better
> job than I could. I saw his previous reply to this mail.)
>
> Having debugged lots of PCI resource and config issues, I understand
> why this is useful and do NOT object to it being included in the tree.

Yeah I thought about this too, but:
  1) it's definitely useful for debugging PCI issues, and much easier for 
everyone if it's in-tree
  2) it only bloats x86 kernels ;)

Documentation is definitely needed though, thanks for catching that.

Thanks,
Jesse
