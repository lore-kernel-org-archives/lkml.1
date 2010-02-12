Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0BLPJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:09:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0BLPJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:09:02 -0500
Date: Fri, 12 Feb 2010 10:09:01 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-sh@vger.kernel.org, linux-parisc@vger.kernel.org,
       sparclinux@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: parsic/sh/sparc tracehook breakage when tracing signals
Message-ID: <20100212150901.GH24051@bombadil.infradead.org>
References: <201002111910.50596.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002111910.50596.vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 07:10:47PM -0500, Mike Frysinger wrote:
> seems like you guys should just change the last argument to:
> 	test_thread_flag(TIF_SINGLESTEP)

Good catch, I've committed a patch to fix this, will send it upstream
today.

regards, Kyle
