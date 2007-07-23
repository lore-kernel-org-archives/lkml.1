Return-Path: <linux-kernel-owner+w=401wt.eu-S935872AbXGWUoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935872AbXGWUoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934409AbXGWUoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:44:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48912 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934407AbXGWUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:44:12 -0400
Date: Mon, 23 Jul 2007 13:44:09 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, arlied@linux.ie,
       Paul Mackerras <paulus@samba.org>, rth@twiddle.net,
       Russell King <rmk@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
       Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Clean up on_each_cpu: should not fail, should not have
 "retry" arg
Message-ID: <20070723134409.2174917a@schroedinger.engr.sgi.com>
In-Reply-To: <1184814434.10380.193.camel@localhost.localdomain>
References: <1184814434.10380.193.camel@localhost.localdomain>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 13:07:14 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Finally, either slub.c's flush_all() can be called with interrupts
> disabled on UP, or the #ifdef is gratuitous.  I assumed the latter.

Correct. flush_all() is always called with interrupts disabled. So its
gratuitous.


