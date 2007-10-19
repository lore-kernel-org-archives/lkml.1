Return-Path: <linux-kernel-owner+w=401wt.eu-S1765630AbXJSGtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765630AbXJSGtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbXJSGti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:49:38 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45484
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbXJSGth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:49:37 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Fri, 19 Oct 2007 01:49:31 -0500
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
References: <200710112011.22000.rob@landley.net> <200710161734.15880.nickpiggin@yahoo.com.au> <20071018130048.GA25084@bitwizard.nl>
In-Reply-To: <20071018130048.GA25084@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710190149.31962.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 8:00:49 am Rogier Wolff wrote:
> So... IMHO, it would be useful to implement something that pages out
> chunks of memory larger than a single hardware page. This would reduce
> the size of the memory management tables (*), as well as improve disk
> throughput if things DO come to paging....

I believe that was more or less the topic of this paper:
  http://kernel.org/doc/ols/2006/ols2006v2-pages-73-78.pdf

Although these seem sort of tangentially related:
  http://kernel.org/doc/ols/2006/ols2006v1-pages-369-384.pdf
  http://kernel.org/doc/ols/2006/ols2006v2-pages-125-130.pdf

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
