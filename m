Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXKNB50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXKNB50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbXKNB5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:57:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755158AbXKNB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:57:16 -0500
Date: Tue, 13 Nov 2007 17:57:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.175208.168903694.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711131756180.6631@schroedinger.engr.sgi.com>
References: <20071106195157.878563669@sgi.com> <20071113.031510.151440585.davem@davemloft.net>
 <p73wssly6sr.fsf@bingen.suse.de> <20071113.175208.168903694.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, David Miller wrote:

> Yes, I've run into similar problems with lockdep as well.
> I had to build an ultra minimalized kernel to get it to
> boot on my Niagara boxes.

Hmmmm. cpu_alloc really does not need zeroed data. Just an address fixed 
by the compiler where stuff can be put. Can the loader do that somehow?


