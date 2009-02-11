Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZBKAWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZBKAWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZBKAWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:22:10 -0500
Received: from cpsmtpo-eml01.KPNXCHANGE.COM ([213.75.38.150]:32798 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815AbZBKAWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:22:09 -0500
From: Frans Pop <elendil@planet.nl>
To: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH][BUILDERR] mm: Fix build error with !CONFIG_HUGETLBFS
Date: Wed, 11 Feb 2009 01:22:03 +0100
User-Agent: KMail/1.9.9
Cc: elendil@planet.nl, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
       torvalds@linux-foundation.org
References: <200902102351.30418.elendil@planet.nl> <200902102351.30418.elendil@planet.nl> <B5B23369-BEA0-4420-9967-28ABC53B3C4B@kernel.crashing.org>
In-reply-To: <B5B23369-BEA0-4420-9967-28ABC53B3C4B@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902110122.04974.elendil@planet.nl>
X-OriginalArrivalTime: 11 Feb 2009 00:22:05.0546 (UTC) FILETIME=[C4AD44A0:01C98BDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> might be slightly better as:
> 
> #define hugetlb_file_setup(name,size,acctflag)  ERR_PTR(-ENOSYS)
> 
> otherwise ack.

Yes, I see. Better to take the patch from Stefan Richter then:
http://lkml.org/lkml/2009/2/10/396
