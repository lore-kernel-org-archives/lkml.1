Return-Path: <linux-kernel-owner+w=401wt.eu-S935301AbXK3QUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301AbXK3QUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 11:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762436AbXK3QUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 11:20:46 -0500
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:35890 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761501AbXK3QUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 11:20:45 -0500
X-Greylist: delayed 1865 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 11:20:44 EST
From: Justin Banks <justinb@bakbone.com>
Date: Fri, 30 Nov 2007 08:37:12 -0700
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Justin Banks <justinb@bakbone.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jon Masters <jonathan@jonmasters.org>, Ray Lee <ray-lk@madrabbit.org>,
       tvrtko.ursulin@sophos.com, Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: Out of tree module using LSM
Message-ID: <20071130153712.GA7959@bleen.domain.actdsltmp>
References: <1196365551.6473.103.camel@perihelion> <20071129214527.1d62056c@the-village.bc.nu> <20071129221238.GF5601@bleen.corp.bb> <20071130014811.GA8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130014811.GA8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote
> On Thu, Nov 29, 2007 at 03:12:38PM -0700, Justin Banks wrote:
> 
> > It's not perfect, but as was recently pointed out, if you can only get
> > 98% of the way there rather than 100% is that a reason for not trying to
> > make it possible?
> 
> BTW, that's a fine example of a common fallacy: "$FOO is 98% of the way to
> $TARGET" does not allow to interpolate the properties of $TARGET to those
> of $FOO.
> 
> Telling that a condom is a 98% approximation to platonic ideal of such is
> not particulary useful, especially if it turns out that what this number 
> really means is that there's a hole on its tip covering 2% of surface...

Understood, but for this use case (and indexing, probably replication,
IDS, and others) hooking at the "normal" VFS layer would provide enough
flexibility to do what's needed. I'm not saying it should be done, only
that it'd work, provide more use cases for linux, and not be totally
unsupportable.

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
