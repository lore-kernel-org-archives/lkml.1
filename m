Return-Path: <linux-kernel-owner+w=401wt.eu-S1161651AbXDXGAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161651AbXDXGAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161652AbXDXGAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:00:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:55246 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161651AbXDXGAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:00:15 -0400
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linas Vepstas <linas@austin.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "<Andrew Morton" <akpm@osdl.org>,
       containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <m1zm4ytjhg.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769695763104-git-send-email-ebiederm@xmission.com>
	 <20070422123155.GF20763@infradead.org>
	 <20070423205020.GR31947@austin.ibm.com>
	 <1177378733.14873.52.camel@localhost.localdomain>
	 <m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
	 <1177382544.14873.57.camel@localhost.localdomain>
	 <m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
	 <1177390842.14873.94.camel@localhost.localdomain>
	 <m1zm4ytjhg.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 15:58:22 +1000
Message-Id: <1177394302.14873.97.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Since we need to have some way to track them having an explicit data
> structure that the callers manage seems to make sense.

Oh sure, I wasn't arguing against that at all...

It might be handy to have a release() callback (optional) that gets
called after the kthread stops/exits, once we know the data structure
isn't going to be used anymore (if practical to implement, depends on
your approach).

Ben.


