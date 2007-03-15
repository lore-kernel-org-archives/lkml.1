Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXCOTOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXCOTOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXCOTOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:14:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37096 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbXCOTOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:14:37 -0400
Date: Thu, 15 Mar 2007 11:08:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       eranian@hpl.hp.com, rdunlap@xenotime.net
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common
 implementation
Message-Id: <20070315110805.262e1fa3.akpm@linux-foundation.org>
In-Reply-To: <45F5FA97.8070705@goop.org>
References: <45F5FA97.8070705@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Mar 2007 18:12:55 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Subject: Simplify smp_call_function*() by using common implementation
> 
> smp_call_function and smp_call_function_single are almost complete
> duplicates of the same logic.  This patch combines them by
> implementing them in terms of the more general
> smp_call_function_mask().

Hopeless, sorry.   It's probably time to start thinking about raising x86
patches against the x86 tree (at least).
