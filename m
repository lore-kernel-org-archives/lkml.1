Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZG3VrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZG3VrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZG3VrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:47:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZG3VrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:47:02 -0400
Date: Thu, 30 Jul 2009 17:46:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
Message-ID: <20090730214659.GA15780@infradead.org>
References: <20090729134125.313191633@de.ibm.com> <20090729134229.529582732@de.ibm.com> <1248876930.28841.161.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248876930.28841.161.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 07:15:30AM -0700, Daniel Walker wrote:
> On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> > plain text document attachment (clocksource-inline.diff)
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Remove clocksource_read, clocksource_enable and clocksource_disable
> > inline functions. No functional change.
> > 
> 
> Your still not really explaining this one, is this suppose to be
> cleaner? Or is this related to some other part of your clean up?

It removes an entirely useless layer of obsfucation.

