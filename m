Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYJWUAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYJWUAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYJWT7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:59:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbYJWT7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:59:51 -0400
Message-ID: <4900D7AE.3010505@redhat.com>
Date: Thu, 23 Oct 2008 15:59:42 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: wierd new config options
References: <20081023181818.GA25430@lst.de>
In-Reply-To: <20081023181818.GA25430@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Why is UNEVICTABLE_LRU and option?  Is there any rason to turn it off or
> is this just to confuse users?

Since the swapout code itself is already configurable with
CONFIG_SWAP, I do believe we want to be able to config out
the unevictable LRU code.

I guess it could be argued that maybe CONFIG_UNEVICTABLE_LRU
should just be folded into CONFIG_SWAP...

-- 
All Rights Reversed
