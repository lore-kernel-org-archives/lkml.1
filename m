Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbXH2Gmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbXH2Gmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 02:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbXH2Gma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 02:42:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:37673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbXH2Gm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 02:42:29 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.23-rc4: maxcpus still broken
Date: Wed, 29 Aug 2007 02:41:35 -0400
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, torvalds@osdl.org, ak@suse.de,
       linux-kernel@vger.kernel.org
References: <20070828111431.GA27707@localhost.sw.ru> <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com> <20070829052331.GB1765@martell.zuzino.mipt.ru>
In-Reply-To: <20070829052331.GB1765@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708290241.36092.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 01:23, Alexey Dobriyan wrote:
> On Wed, Aug 29, 2007 at 06:03:34AM +0100, Hugh Dickins wrote:
> > On Wed, 29 Aug 2007, Alexey Dobriyan wrote:
> > > On Wed, Aug 29, 2007 at 01:35:57AM +0200, Michal Piotrowski wrote:
> > > > On 28/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > > > Every time I try to boot with maxcpus=1 it dies show_stat():
> > > > 
> > > > Is this a regression?
> > > 
> > > yep
> > 
> > A regression since when, I wonder?
> 
> Anything before "ACPI: boot correctly with "nosmp" or "maxcpus=0"" is
> fine.

In 2.6.23-rc4, maxcpus=1 is working for me, with and without acpi=off.
Can you post the failing .config?

thanks,
-Len
