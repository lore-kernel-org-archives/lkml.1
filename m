Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZKMAGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZKMAGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 19:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZKMAGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 19:06:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1031 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZKMAGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 19:06:10 -0500
Subject: Re: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
From: Joe Perches <joe@perches.com>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <hdi6ut$cs9$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
	 <hdi6ut$cs9$1@taverner.cs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 16:06:15 -0800
Message-ID: <1258070775.9696.20.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 23:49 +0000, David Wagner wrote:
> Julia Lawall  wrote:
> > As observed by Joe Perches, sizeof of a constant string includes the
> > trailing 0.  If what is wanted is to check the initial characters of
> > another string, this trailing 0 should not be taken into account.  If an
> > exact match is wanted, strcmp should be used instead.
> A caution: Your patch changes behavior.  Is there a specific reason
> to believe that the change in behavior is what is desired/intended in
> this context?  Lacking any analysis that indicates that the change in
> behavior is desired, I'm skeptical that a behavior-changing patch should
> be applied.

I agree that desired behavior should be known before
patches are applied.

Most likely, this instance should just be strcmp.

That gives better readability, trivially improved
performance, and easier verification.

