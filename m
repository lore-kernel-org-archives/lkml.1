Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZBGRMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZBGRMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZBGRL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:11:57 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:47435 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZBGRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:11:56 -0500
Date: Sat, 7 Feb 2009 20:12:07 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] cpumask: Use cpu_*_mask accessors code: alpha
Message-ID: <20090207171207.GA32252@jurassic.park.msu.ru>
References: <200902071353.12571.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902071353.12571.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 01:53:11PM +1030, Rusty Russell wrote:
> This also removes the bug introduced in ee0c468b (alpha: compile
> fixes) which had Alpha setting bits on an on-stack cpumask, not the
> cpu_online_map.

Ouch. Shame on me.

> (Trivial, but untested!)

Compiles cleanly, thanks.

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.
