Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbZGXEdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbZGXEdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZGXEdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:33:43 -0400
Received: from waste.org ([66.93.16.53]:42959 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZGXEdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:33:42 -0400
Subject: Re: [PATCH 0/1] pagemap clear_refs: modify to specify anon or
 mapped vma clearing
From: Matt Mackall <mpm@selenic.com>
To: "Moussa A. Ba" <moussa.a.ba@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       akpm@linux-foundation.org, adobriyan@gmail.com, mel@csn.ul.ie,
       yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
In-Reply-To: <4A6930F5.3090008@gmail.com>
References: <4A6930F5.3090008@gmail.com>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 23:30:07 -0500
Message-Id: <1248409807.24185.18.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 20:56 -0700, Moussa A. Ba wrote:
> This patch makes the clear_refs proc interface a bit more versatile. It 
> adds support for clearing either anonymous, file mapped pages or both.
> 
> echo 1 > /proc/pid/clear_refs clears ANON pages
> echo 2 > /proc/pid/clear_refs clears file mapped pages
> echo 3 > /proc/pid/clear_refs clears all pages
> 
> Selectively clearing pages has a measurable impact on performance as it 
> decreases the number of page walks.  We have been using this interface 
> and this adds flexibility to the user space application implementing the 
> reference clearing.

[adding David, the original instigator of clear_refs)

First, don't send 0 of 1 messages, especially for a single patch. It
makes Andrew curse and makes him more likely to consider other
employment possibilities. Instead incorporate highly useful info like
the above into your patch instead, preferably as docs and commit
descriptions.

Second, depending on how we've documented the behavior of this file,
this looks like it might break existing tools that are currently writing
'1' but expecting the behavior of '3'?

-- 
http://selenic.com : development and support for Mercurial and Linux


