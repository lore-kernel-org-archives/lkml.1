Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbZBLAyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbZBLAyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZBLAyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:54:10 -0500
Received: from ns1.coraid.com ([12.51.113.4]:33977 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753980AbZBLAyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:54:10 -0500
Date: Wed, 11 Feb 2009 19:55:49 -0500
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, karaluh@karaluh.pl
Subject: Re: [PATCH 1/1] aoe: ignore vendor extension AoE responses
Message-ID: <20090212005549.GA8636@coraid.com>
References: <1234397804-9034-1-git-send-email-ecashin@coraid.com> <20090211162944.c1cdf8fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211162944.c1cdf8fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 04:29:44PM -0800, Andrew Morton wrote:
> On Wed, 11 Feb 2009 19:16:44 -0500
> Ed Cashin <ecashin@coraid.com> wrote:
> 
> > The Welland ME-747K-SI AoE target generates unsolicited AoE
> > responses that are marked as vendor extensions.  Instead of
> > ignoring these packets, the aoe driver was generating kernel
> > messages for each unrecognized response received.  This patch
> > corrects the behavior.

...
> Do you believe that this fix should be backported into earlier kernel
> versions?  (2.6.28.x, 2.6.27.x, etc)

It shouldn't hurt, it can help, and it's well tested.

I am not sure how many environments have AoE packets that have vendor
extension command types, though, so I can't gauge how pressing the
need is for backporting.

If the cost of backporting is low, it probably should be backported.

-- 
  Ed Cashin <ecashin@coraid.com>
