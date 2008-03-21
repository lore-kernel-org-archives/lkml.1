Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYCUHFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYCUHFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYCUHFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:05:21 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48939 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540AbYCUHFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:05:20 -0400
Date: Fri, 21 Mar 2008 00:03:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [14/14] vcompound: Avoid vmalloc for ehash_locks
In-Reply-To: <47E35D73.6060703@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0803210002450.15903@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061727.491610308@sgi.com>
 <47E35D73.6060703@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Eric Dumazet wrote:

> But, isnt it defeating the purpose of this *particular* vmalloc() use ?

I thought that was controlled by hashdist? I did not see it used here and 
so I assumed that the RR was not intended here.
