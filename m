Return-Path: <linux-kernel-owner+w=401wt.eu-S1423094AbXEDT1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423094AbXEDT1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766586AbXEDT1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:27:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42469 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423094AbXEDT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:27:34 -0400
Date: Fri, 4 May 2007 12:24:07 -0700
From: Greg KH <greg@kroah.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: incoming
Message-ID: <20070504192407.GA32235@kroah.com>
References: <20070504091434.106ad04d.akpm@linux-foundation.org> <20070504185721.3CB7C1800A0@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504185721.3CB7C1800A0@magilla.sf.frob.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 11:57:21AM -0700, Roland McGrath wrote:
> > Ah.  The patch affects security code, but it doesn't actually address any
> > insecurity.  I didn't think it was needed for -stable?
> 
> I would not recommend it for -stable.  
> It is an ABI change for the case of a security refusal.

ABI changes are not a problem for -stable, so don't let that stop anyone
:)

thanks,

greg k-h
