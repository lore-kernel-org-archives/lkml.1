Return-Path: <linux-kernel-owner+w=401wt.eu-S1946357AbXD3Qat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946357AbXD3Qat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946356AbXD3Qat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:30:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:47508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946359AbXD3Qar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:30:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules too
Date: Mon, 30 Apr 2007 18:30:26 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Hellwig <hch@infradead.org>, mingo@elte.hu, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <200704301227.598020000@suse.de> <20070430105009.GB14944@infradead.org> <20070430155548.381d1bad@the-village.bc.nu>
In-Reply-To: <20070430155548.381d1bad@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301830.26556.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 16:55:48 Alan Cox wrote:
> On Mon, 30 Apr 2007 11:50:09 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
> > > 
> > > Otherwise non GPL modules cannot even do basic operations
> > > like disabling interrupts anymore, which would be excessive.
> > > 
> > > Longer term should split the single structure up into
> > > internal and external symbols and not export the internal
> > > ones at all.
> > > 
> > > Signed-off-by: Andi Kleen <ak@suse.de>
> > 
> > Ingo was dead-set against this and I kinda agree. 
> 
> Ditto - do the work first then merge it.

Ok. Jeremy has come up with a ingenious simple solution. He promised 
a patch.

-Andi
