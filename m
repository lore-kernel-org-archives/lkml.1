Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXD3LA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXD3LA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbXD3LA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:00:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:45019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675AbXD3LA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:00:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules too
Date: Mon, 30 Apr 2007 13:00:31 +0200
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200704301227.598020000@suse.de> <20070430102814.7E56E151D2@wotan.suse.de> <20070430105009.GB14944@infradead.org>
In-Reply-To: <20070430105009.GB14944@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301300.31298.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 12:50:09 Christoph Hellwig wrote:
> On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
> > 
> > Otherwise non GPL modules cannot even do basic operations
> > like disabling interrupts anymore, which would be excessive.
> > 
> > Longer term should split the single structure up into
> > internal and external symbols and not export the internal
> > ones at all.
> > 
> > Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Ingo was dead-set against this and I kinda agree. 

The problem is that without this non GPL modules cannot even disable
interrupts anymore. That is imho too radical.

-Andi

