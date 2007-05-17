Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbXEQOo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbXEQOo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXEQOoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:44:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33945 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbXEQOoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:44:22 -0400
Date: Thu, 17 May 2007 15:44:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
Message-ID: <20070517144420.GA3529@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	akpm@osdl.org
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165454.5845.30875.sendpatchset@localhost.localdomain> <20070219105927.GB16930@infradead.org> <1171976456.4039.21.camel@sauron> <20070225055828.GC9137@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225055828.GC9137@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 05:58:28AM +0000, Christoph Hellwig wrote:
> > Why not? We tried to avoid this but found out that this is the most
> > decent interface. Specific advises are welcome.
> 
> because this type of compount interface is really painful for the user.
> the module.param=foo syntax makes sure paramaters can be used without
> endless documentation for each and every single of them, and makes
> sure module writers don't introduce bugs in their own parser reimplementations.
> 
> Rusty, was it intentional that drivers can use __module_param_call?
> Do you think the ubi use here is okay?

So both I and Rusty told you not to do this and you did it anyway.

I'm quite pissed about this ignorance.  Andrew, what do we do about such
a case?  Should we just revert ubi until they fixed their mess up?
