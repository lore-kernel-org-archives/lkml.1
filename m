Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZCKByz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZCKByz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZCKByp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:54:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40351 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZCKByo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:54:44 -0400
Date: Wed, 11 Mar 2009 03:14:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH for -tip] x86, mce: use round_jiffies() instead round_jiffies_relative()
Message-ID: <20090311021405.GE11935@one.firstfloor.org>
References: <20090311100925.A7FA.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311100925.A7FA.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:14:26AM +0900, KOSAKI Motohiro wrote:
> Impact: saving power _very_ little
> 
> round_jiffies() round up absolute jiffies to full second.
> round_jiffies_relative() round up relative jiffies to full second.
> 
> The "t->expires" is absolute jiffies. Then, round_jiffies() should be
> used instead round_jiffies_relative().

Thanks. I have a rewrite of this code pending. I added it to this.

-Andi
