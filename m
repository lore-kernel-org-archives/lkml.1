Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYGASOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYGASOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYGASOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:14:11 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2467 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYGASOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:14:10 -0400
Subject: Re: [RFC PATCH] - scripts/CodingStyle_sizeof - standardize sizeof
	and [PATCH] drivers/infiniband - standardize sizeof(foo)
From: Joe Perches <joe@perches.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org
In-Reply-To: <adar6adcwss.fsf@cisco.com>
References: <1214930986.26073.40.camel@localhost>
	 <adar6adcwss.fsf@cisco.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 10:37:44 -0700
Message-Id: <1214933864.26073.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 10:57 -0700, Roland Dreier wrote:
> This seems like needless churn to me.  I personally prefer to see
> "sizeof foo" instead of "sizeof(foo)", since sizeof is not a function,
> and in any case I don't see much value in making this type of trivial
> change.

No value but standardization and ease of grep.

fyi: drivers/infiniband uses 3 different styles for sizeof.
Your preferred style is not the most frequently used.

$ grep -Pr --include=*.[ch] "\bsizeof\(" drivers/infiniband | wc -l
785
$ grep -Pr --include=*.[ch] "\bsizeof\s+\(" drivers/infiniband | wc -l
226
$ grep -Pr --include=*.[ch] "\bsizeof\s+[^\(]" drivers/infiniband | wc -l
523

cheers, Joe

