Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbXH2FXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbXH2FXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXH2FXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:23:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:37401 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXH2FXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=A8f6kMLwuO+PjmSG1K8ibpQvbD0VgLwumz1hAIZJvEiKUAqbnKb/63cYMQeiA6HBt8e2ZcAY3chJ59pCi9JCn4oC/NSxcvHW+bxnPM0gTImyu0vaubCE+luGK7TBsWb13e7eVyj+TEQ69HOvNQr4cWAsI+SuiU/6juHbHF2kbLg=
Date: Wed, 29 Aug 2007 09:23:31 +0400
To: Hugh Dickins <hugh@veritas.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, torvalds@osdl.org,
       len.brown@intel.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4: maxcpus still broken
Message-ID: <20070829052331.GB1765@martell.zuzino.mipt.ru>
References: <20070828111431.GA27707@localhost.sw.ru> <6bffcb0e0708281635v2fdca60bv40099d0583599637@mail.gmail.com> <20070829043921.GA1765@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 06:03:34AM +0100, Hugh Dickins wrote:
> On Wed, 29 Aug 2007, Alexey Dobriyan wrote:
> > On Wed, Aug 29, 2007 at 01:35:57AM +0200, Michal Piotrowski wrote:
> > > On 28/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > > Every time I try to boot with maxcpus=1 it dies show_stat():
> > > 
> > > Is this a regression?
> > 
> > yep
> 
> A regression since when, I wonder?

Anything before "ACPI: boot correctly with "nosmp" or "maxcpus=0"" is
fine.
