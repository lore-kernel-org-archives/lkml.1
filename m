Return-Path: <linux-kernel-owner+w=401wt.eu-S1161584AbXDXEfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161584AbXDXEfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbXDXEfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:35:06 -0400
Received: from ozlabs.org ([203.10.76.45]:40796 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbXDXEfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:35:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17965.35054.835790.275270@cargo.ozlabs.ibm.com>
Date: Tue, 24 Apr 2007 14:34:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linas Vepstas <linas@austin.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "<Andrew Morton" <akpm@osdl.org>,
       containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
In-Reply-To: <m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695763104-git-send-email-ebiederm@xmission.com>
	<20070422123155.GF20763@infradead.org>
	<20070423205020.GR31947@austin.ibm.com>
	<1177378733.14873.52.camel@localhost.localdomain>
	<m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
	<1177382544.14873.57.camel@localhost.localdomain>
	<m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman writes:

> Well the basic problem is that for any piece of code that can be modular
> we need a way to ensure all threads it has running are shutdown when we
> remove the module.

The EEH code can't be modular, and wouldn't make any sense to be
modular, since it's part of the infrastructure for accessing PCI
devices.

Paul.
