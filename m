Return-Path: <linux-kernel-owner+w=401wt.eu-S1763403AbXKMWaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763403AbXKMWaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762187AbXKMW3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:29:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761947AbXKMW3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:29:36 -0500
Date: Tue, 13 Nov 2007 22:29:29 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       gregkh@suse.de, akpm@osdl.org, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sourceforge.net, perfmon@napali.hpl.hp.com
Subject: Re: perfmon2 merge news
Message-ID: <20071113222929.GC1322@infradead.org>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <20071113183239.GF4319@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113183239.GF4319@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 10:32:39AM -0800, Stephane Eranian wrote:
> It would obvisouly cause a lot of troubles to existing perfmon libraries and
> applications (e.g. PAPI). It would also be fairly tricky to do because you'd 
> have to make sure that in the beginning, you leave enough flexiblity such that
> you can add the rest while maintaining total backward compatibility. But given
> that we already have the full solution, it could just be a matter of dropping
> features without disrupting the user level API.

There no way we'll keep this completely idiotic userland API.  If people start
to use out of tree APIs they can pretty much expect that they're not going
to stay around.  And in this case they most certainly won't.

