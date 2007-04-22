Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXDVWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXDVWqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 18:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXDVWqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 18:46:31 -0400
Received: from ozlabs.org ([203.10.76.45]:33444 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbXDVWqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 18:46:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17963.58820.295008.169336@cargo.ozlabs.ibm.com>
Date: Mon, 23 Apr 2007 08:46:28 +1000
From: Paul Mackerras <paulus@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] macintosh/therm_pm72.c: Convert to kthread API.
In-Reply-To: <20070422191647.GA14995@infradead.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695832169-git-send-email-ebiederm@xmission.com>
	<20070422191647.GA14995@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig writes:

> Why is this driver using a thread at all?  It's only doing a bunch
> of rather short-lived things in the thread.

It's doing i2c reads and writes, which block, and are actually quite
slow.

Paul.
