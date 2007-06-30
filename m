Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbXF3Iih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbXF3Iih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 04:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXF3Iia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 04:38:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58934 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXF3Ii3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 04:38:29 -0400
Date: Sat, 30 Jun 2007 09:38:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
Message-ID: <20070630083827.GA21102@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rodolfo Giometti <giometti@enneenne.com>,
	David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1182960660.1170.12.camel@pmac.infradead.org> <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628161450.GD13886@enneenne.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 06:14:50PM +0200, Rodolfo Giometti wrote:
> Hello,
> 
> here my new LinuxPPS patch.
> 
> What to do now for kernel inclusion? Should I provide several patches?
> If so how should I divide them?
> 
> Thanks a lot,

Sorry for coming in that late, but using syscalls for something as
periphal sounds like a very bad idea to me, and the syscalls aren't
defined nicely either (e.g. you have an ioctl lookalike).  I'd say
back to the drawingboard.

And yes, even ioctls are nicer than badly designed syscalls :)

Also code seems to be odd at least in a few places, e.g. all the access_oks
and double checks of the ioctl-lookalike commands should go.
