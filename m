Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXIYKjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXIYKjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbXIYKi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:38:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35006 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbXIYKiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:38:55 -0400
Date: Tue, 25 Sep 2007 12:40:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, mathieu.desnoyers@polymtl.ca,
       akpm <akpm@linux-foundation.org>, davem@davemloft.net
Subject: Re: [PATCH/RFC] samples/: move kprobes sources to samples
Message-ID: <20070925104019.GA11699@uranus.ravnborg.org>
References: <20070924145828.d279abac.randy.dunlap@oracle.com> <20070925084333.GA16077@in.ibm.com> <20070925085711.GA11285@infradead.org> <20070925100053.GA16731@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925100053.GA16731@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ananth.

> o Removed samples/Kbuild so the build goes on fine

You could have added the obj-y assignment to Kbuild
for the same effect.
Kbuild is the first filename searched by kbuild, next is Makefile.

	Sam
