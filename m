Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbYACMcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbYACMcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 07:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYACMbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 07:31:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYACMbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 07:31:52 -0500
Date: Thu, 3 Jan 2008 10:30:36 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Whitcroft <andyw@uk.ibm.com>,
       Christer Weinigel <christer@weinigel.se>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
Message-ID: <20080103123036.GB29523@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andy Whitcroft <andyw@uk.ibm.com>,
	Christer Weinigel <christer@weinigel.se>,
	linux-kernel@vger.kernel.org
References: <20071202130335.690a8daf@cw05lap> <20080103111058.GE10861@shadowen.org> <20080103122610.GA18255@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103122610.GA18255@infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 03, 2008 at 12:26:10PM +0000, Christoph Hellwig escreveu:
> On Thu, Jan 03, 2008 at 11:10:58AM +0000, Andy Whitcroft wrote:
> > We have had some stabs at changing this, but no consensus was reached on
> > whether it was a "for" or a "function".  My memory is of there being
> > slightly more "without a space" tenders than the other and so it has not
> > been changed.  This thread also seems so far to have not really
> > generated a concensus.  So I would tend to leave things as they are.  
> > 
> > A third option might be to accept either on *for_each* constructs.
> > That might tend to lead to divergance.  Difficult.  However, also see my
> > later comments on "style guide".
> 
> Pretty much all core code uses list_for_each_entry( so new code should
> follow that example.

Agreed, CodingStyle is not about mindless consistency such as "for (" is
the right thing, so "list_for_each (" is consistent with it, it is about
codifying practice contributors got used to over the years.

- Arnaldo
