Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbXGXObl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbXGXObl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763225AbXGXObL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:31:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58946 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbXGXObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:31:08 -0400
Date: Tue, 24 Jul 2007 15:31:03 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH respin, was PATCH for review] During VM oom condition, kill all threads in process group
Message-ID: <20070724143103.GA25924@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Will Schmidt <will_schmidt@vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>, Andi Kleen <ak@suse.de>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20070719348.540885000@suse.de> <20070719134840.47B5114E6E@wotan.suse.de> <20070719140411.GD16279@infradead.org> <Pine.LNX.4.64.0707191614180.7377@anakin> <1185214185.22237.30.camel@farscape.rchland.ibm.com> <20070723141641.5759a287.akpm@linux-foundation.org> <1185287324.22237.39.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185287324.22237.39.camel@farscape.rchland.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 09:28:44AM -0500, Will Schmidt wrote:
> > Just checking...
> > 
> > blackfin
> > h8300
> > m68knommu
> > uml
> > v850
> > 
> > were not changed.  Intentional?
> 
> Yes.  Those arch's don't have the VM oom code that I could see.   There
> is an occasional do_exit() reference elsewhere in the fault handler
> code, for reasons other than VM oom, so I deliberately didn't touch
> those either.    

Except for uml these are the !CONFIG_MMU only architectures, so that makes
a lot of sense.
