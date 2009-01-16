Return-Path: <linux-kernel-owner+w=401wt.eu-S934976AbZAPB5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934976AbZAPB5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbZAPB5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:57:11 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:29098 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZAPB5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:57:10 -0500
Message-ID: <496FE973.1060106@hp.com>
Date: Thu, 15 Jan 2009 17:57:07 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, leedom@chelsio.com
Subject: Re: [PATCH 2.6.28] cxgb3 - Fix LRO misalignment
References: <20090116004829.7437.52798.stgit@speedy5>
In-Reply-To: <20090116004829.7437.52798.stgit@speedy5>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> The lro manager's frag_align_pad setting was missing,
> leading to misaligned access to the skb passed up
> to the stack.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

I have tried this in a tree I have, and where I was once seeing unaligned access 
messages on an ia64 system with LRO enabled, now I see none.

Tested-by: Rick Jones <rick.jones2@hp.com>

rick jones
