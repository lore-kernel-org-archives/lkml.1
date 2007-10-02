Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbXJBPnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbXJBPnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXJBPm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:42:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3050 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbXJBPm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:42:59 -0400
Subject: Re: [patch] printk: add KERN_CONT annotation
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071002051852.GC28345@elte.hu>
References: <20070928105345.GC18163@shadowen.org>
	 <20071001064448.GA4239@elte.hu>
	 <20071001003007.4e90143b.akpm@linux-foundation.org>
	 <20071002043408.GM10199@1wt.eu>  <20071002051852.GC28345@elte.hu>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 08:41:32 -0700
Message-Id: <1191339692.13170.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 07:18 +0200, Ingo Molnar wrote:
> +#define	KERN_CONT	""

This doesn't work with printk(char** array[index]) continuations
or with strings with embedded KERN_ prefixes.

printk(array[index])
printk(version)


