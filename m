Return-Path: <linux-kernel-owner+w=401wt.eu-S1763630AbXKTUsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763630AbXKTUsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbXKTUs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:48:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39110 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759995AbXKTUs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:48:27 -0500
Date: Tue, 20 Nov 2007 12:48:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 44/45] Remove local_t support
In-Reply-To: <20071120125944.GD10127@Krystal>
Message-ID: <Pine.LNX.4.64.0711201246500.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011342.188333766@sgi.com>
 <20071120125944.GD10127@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:

> The question that arises is : are there some architectures that do not
> provide fast PER_CPU ops but provides fast local atomic ops ?

There were only a few no critical users of local_t before this patch. So I 
doubt that it matters.
