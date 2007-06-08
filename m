Return-Path: <linux-kernel-owner+w=401wt.eu-S1030345AbXFHIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030345AbXFHIMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968536AbXFHIEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:04:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968533AbXFHIEI (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:04:08 -0400
Date: Fri, 8 Jun 2007 09:04:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: carsteno@de.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608080401.GA17684@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	carsteno@de.ibm.com, Jared Hulbert <jaredeh@gmail.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com> <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com> <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com> <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46690C58.7090304@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 09:59:20AM +0200, Carsten Otte wrote:
> Christoph Hellwig wrote:
> >Jared's patch currently does ioremap on mount (and no iounmap at all).
> >That mapping needs to move from the filesystem to the device driver.
> The device driver needs to do ioremap on open(), and iounmap() on 
> release. That's effectively what our block driver does.

Yes, exactly.
