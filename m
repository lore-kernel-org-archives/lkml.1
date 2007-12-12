Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbXLLRqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbXLLRqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXLLRqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:46:15 -0500
Received: from mail.fieldses.org ([66.93.2.214]:36187 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbXLLRqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:46:15 -0500
Date: Wed, 12 Dec 2007 12:46:13 -0500
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A peek at the future of storage
Message-ID: <20071212174613.GA16656@fieldses.org>
References: <200712120846.18320.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712120846.18320.phillips@phunq.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 08:46:18AM -0800, Daniel Phillips wrote:
> Incidentally, we ran our tests with 128 knfsd threads.  The default of 8 
> threads produces miserable performance on the SSD, which gave us a good 
> scare on our initial test run.  It would be very nice to implement an 
> algorithm to scale the knfsd thread pool automatically, in order to 
> eliminate this class of thing that can go wrong.  If somebody became 
> inspired to take on that little project that would be great, otherwise 
> it is in our pipeline for, hmm, Christmas delivery.  (Exactly which 
> Christmas is left unspecified.)

People have proposed writing a daemon that just reads /proc/net/rpc/nfsd
periodically and uses that to adjust the number of threads from
userspace, probably subject to some limits in a config file someplace.
(Think that could do the job, or is there some reason this would be
easier in the kernel?)

--b.
