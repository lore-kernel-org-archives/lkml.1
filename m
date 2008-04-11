Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbYDKVLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbYDKVLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbYDKVLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:11:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:64104 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761992AbYDKVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sQZqgECePxBqj+Zlm5haEIXy5StSO5AbKnLTQDbwb2AQPEskE1b0eAuPB3gTd1NEUf+7n8Zdmvrm2weFOK4R2OiMpDAND6bwfV8sCMfRl3Rc4RGMLpsM+6pIgYx6dOt97V7iTovI0oFCv2sF1dx2v6cPK8lQNdZNIhNw21mTTyI=
Date: Sat, 12 Apr 2008 01:07:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: 2.6.25-rc8-mm2: boot hang after "ACPI: using IOAPIC for
	interrupt routing"
Message-ID: <20080411210715.GA4851@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411062928.GB4748@martell.zuzino.mipt.ru> <1207910128.7212.4.camel@haji>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207910128.7212.4.camel@haji>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 01:35:28PM +0300, Pekka Enberg wrote:
> On Fri, 2008-04-11 at 10:29 +0400, Alexey Dobriyan wrote:
> > On Thu, Apr 10, 2008 at 08:33:54PM -0700, Andrew Morton wrote:
> > > - git-slub has been temporarily replaced by git-pekka.  Pekka is standing in
> > >   while Christoph is away.
> > 
> > I bisected boot hang after "ACPI: using IOAPIC for interrupt routing"
> > down to git-pekka.
> > 
> > normal dmesg from 2.6.25-rc8-something and .config snippets for -mm
> 
> Alexey, can you try passing the 'slub_nomerge' option to the kernel to
> see if the hang goes away with that?

nomerge doesn't help as well as turning on combinations of SLUB debug options.

