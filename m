Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbZJAOUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbZJAOUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbZJAOUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:20:19 -0400
Received: from fifo99.com ([67.223.236.141]:51663 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591AbZJAOUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:20:07 -0400
Subject: Re: [PATCH 1/5] checkpatch: fix false errors due to macro
 concatenation
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090930174612.GE2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <20090930174612.GE2957@shadowen.org>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 07:20:04 -0700
Message-Id: <1254406804.18167.90.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 18:46 +0100, Andy Whitcroft wrote:

> Ok, just removing these characters in the conversion changes the
> relative length of the converted form and breaks position reporting for
> other checks, for instance if I stupidly convert the ## to # so its
> still invalid we then get this:
> 
> +	entry = (struct ftrace_raw_##call *)raw_data; \
> 
> It is probabally more correct to include this <ident> ## <ident> form in
> the definition of an identifier.  I've respun this patch to do just that
> and it looks like its working as we would hope.

It could just become "__" something that would match on an ident and
keep the spacing the same.

Daniel

