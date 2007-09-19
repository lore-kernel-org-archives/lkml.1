Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXISSLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXISSLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXISSK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:10:56 -0400
Received: from pat.uio.no ([129.240.10.15]:33195 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbXISSKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:10:55 -0400
Subject: Re: [PATCH 03/24] create cleanup helper svc_msnfs()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>,
       "Dr. J. Bruce Fields" <bfields@fieldses.org>,
       Neil Brown <neilb@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070919175909.GA24530@infradead.org>
References: <20070917182718.70494C9B@kernel>
	 <20070917182721.8EF73A09@kernel>
	 <Pine.LNX.4.64.0709191939080.10201@fbirervta.pbzchgretzou.qr>
	 <1190223930.26982.109.camel@localhost>
	 <1190224446.6734.4.camel@heimdal.trondhjem.org>
	 <20070919175909.GA24530@infradead.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 14:10:32 -0400
Message-Id: <1190225432.6734.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.077)
X-UiO-Scanned: D260BC50D0AB8720A04A595F47D6C1911DD1AA3E
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 132 total 3988861 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 18:59 +0100, Christoph Hellwig wrote:
> On Wed, Sep 19, 2007 at 01:54:06PM -0400, Trond Myklebust wrote:
> > > If it were some kind of larger API, we could come up with something
> > > better.  But, for a single isolated user, I think it is OK.
> > 
> > The msnfs option means enable the use of MS Windows share locks, so yes,
> > the name is appropriate.
> 
> Yepp.  While we're at it, can we please kill the silly ifdefs for it
> (once Dave's patches are merged to avoid conflicts).  The code has always
> been enabled since it was introduced, it's an export option anyway and
> to make things worse the ifdef needs to be disabled in multiple files
> to make it consistant..

I'm sure that either Neil or Bruce would be happy to take such a patch.

Cheers
  Trond

