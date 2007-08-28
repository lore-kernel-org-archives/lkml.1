Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbXH1M0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbXH1M0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXH1M01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:26:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55124 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXH1M00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:26:26 -0400
Date: Tue, 28 Aug 2007 13:26:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       davem@davemloft.net
Subject: Re: [PATCH] clean up exports in fs/{open,read_write}.c
Message-ID: <20070828122623.GA16800@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>, davem@davemloft.net
References: <20070824033310.GA5662@kernel.sg> <20070827213747.GA17049@infradead.org> <46D354DD.6000208@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D354DD.6000208@linux.intel.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 03:49:01PM -0700, Arjan van de Ven wrote:
> Christoph Hellwig wrote:
> >On Fri, Aug 24, 2007 at 11:33:10AM +0800, Eugene Teo wrote:
> >>Takashi-san fixed sound/isa/wavefront/wavefront_synth.c to use
> >>request_firmware instead of sys_*. Since that is the last driver in the
> >>kernel that uses sys_{read,close}, this patch kills these exports. 
> >>sys_open
> >>is left exported for sparc64 only.
> >
> >I can't find any spar user of it, so please kill it.  
> 
> it's in the solaris compat code which is modular

While it does use some sys_ symbols, I can't find it use sys_open.

