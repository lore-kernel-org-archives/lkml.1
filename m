Return-Path: <linux-kernel-owner+w=401wt.eu-S1764979AbXGXUlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764979AbXGXUlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbXGXUl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:41:26 -0400
Received: from disorder.primate.net ([198.144.194.12]:47522 "EHLO
	disorder.primate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbXGXUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:41:25 -0400
Date: Tue, 24 Jul 2007 13:41:15 -0700
From: Aaron Porter <atporter@primate.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
Message-ID: <20070724204114.GF24543@primate.net>
References: <20070724172513.GB24543@primate.net> <p73vec9sknz.fsf@bingen.suse.de> <20070724184908.GD24543@primate.net> <20070724191347.GB359@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724191347.GB359@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 09:13:47PM +0200, Andi Kleen wrote:

> You have slab debugging enabled. That makes everything slow.
> It costs you ~66% of your CPU time.  Disable it.

	Past peak for the day, but this does look like the culprit. Thanks
to all who replied.
