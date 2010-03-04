Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0CDVk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:40:28 -0500
Received: from mail.perches.com ([173.55.12.10]:1392 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab0CDVk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:40:27 -0500
Subject: Re: [RFC PATCH] printk: Convert pr_<level> macros to functions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100304133407.2d5996d7.akpm@linux-foundation.org>
References: <1267629618.8926.73.camel@Joe-Laptop.home>
	 <20100304124943.ce7c1a63.akpm@linux-foundation.org>
	 <1267738192.12993.48.camel@Joe-Laptop.home>
	 <20100304133407.2d5996d7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 13:40:26 -0800
Message-ID: <1267738826.12993.57.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 13:34 -0800, Andrew Morton wrote: 
> Obviously one would need eight little functions, each of which calls
> pr_everything().

Those little function still need to individually use
va_list so it's just as easy to call printk directly
as long as %pV is OK.

What do you think of the %pV use?


