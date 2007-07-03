Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXGDDXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXGDDXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbXGDDXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:23:32 -0400
Received: from ozlabs.org ([203.10.76.45]:60438 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXGDDXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:23:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18058.56956.595143.15424@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 09:40:44 +1000
From: Paul Mackerras <paulus@samba.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
	pathway
In-Reply-To: <200707031355.51028.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031307.41366.oliver@neukum.org>
	<1183463053.10386.112.camel@localhost.localdomain>
	<200707031355.51028.oliver@neukum.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum writes:

> That's why we have the problem of freezing the kernel threads or not.

That problem is a symptom of the deeper conceptual problem, as is the
problem with FUSE.

> You want to have all that pain for fuse?

I'd certainly rather get the drivers right, and maybe have an
occasional deadlock if I miss something, than have a GUARANTEED
deadlock every time I suspend with a FUSE filesystem mounted (which is
pretty much every time, since I use encfs regularly).

Paul.
