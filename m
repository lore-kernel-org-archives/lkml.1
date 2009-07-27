Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZG0UgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZG0UgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZG0UgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:36:21 -0400
Received: from waste.org ([66.93.16.53]:42342 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbZG0UgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:36:20 -0400
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or
 mapped vma clearing
From: Matt Mackall <mpm@selenic.com>
To: "Moussa A. Ba" <moussa.a.ba@gmail.com>
Cc: linux-kernel@vger.kernel.org, Amerigo Wang <xiyou.wangcong@gmail.com>,
       akpm@linux-foundation.org, adobriyan@gmail.com, mel@csn.ul.ie,
       yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
In-Reply-To: <4A6E0BD6.50102@gmail.com>
References: <4A693122.6060503@gmail.com>
	 <20090724083926.GA6372@cr0.nay.redhat.com>  <4A6E0BD6.50102@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 15:30:09 -0500
Message-Id: <1248726609.1374.425.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 13:19 -0700, Moussa A. Ba wrote:
> This patch makes the clear_refs proc interface a bit more versatile.
> It adds support  for clearing anonymous pages, file mapped pages or both.
> 
> The clear_refs entry is used to reset the Referenced bits on virtual and
> physical pages associated with a process.
> echo 1 > /proc/PID/clear_refs clears all pages associated with the process
> echo 2 > /proc/PID/clear_refs clears anonymous pages only
> echo 3 > /proc/PID/clear_refs clears file mapped pages only
> Any other value written to the proc entry will clear all pages.
> 
> Selective clearing the pages has a measurable impact on performance as it
> limits the number of page walks.  We have been using this interface and  this
> adds flexibility to the user user space application implementing the reference
> clearing.

Looks ok to me.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


