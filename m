Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZBIP5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZBIP5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZBIP5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:57:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZBIP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:57:09 -0500
Date: Mon, 9 Feb 2009 10:57:02 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Kyle McMartin <kyle@infradead.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Build failure with latest -git: btrfs on ppc64
Message-ID: <20090209155702.GB13529@bombadil.infradead.org>
References: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com> <20090207232458.GB23407@bombadil.infradead.org> <1234191446.1262.3.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234191446.1262.3.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 09:57:26AM -0500, Chris Mason wrote:
> 
> Ok, I thought this would be defined to something simple for the
> non-ticket users, should I just not be using this call?  
> 

I think the use is fine, since it's really a judgement call based on
whether there's waiters for the ticket. I need to take a closer look
at where this is used to say...

It's inevitable for you to hit things like this though, as far as I know
you're the first user of this lock interface. :)

regards, Kyle
