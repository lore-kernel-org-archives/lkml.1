Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbXKTUQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbXKTUQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXKTUQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:16:42 -0500
Received: from relay1.sgi.com ([192.48.171.29]:35840 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752404AbXKTUQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:16:41 -0500
Date: Tue, 20 Nov 2007 12:16:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 01/45] ACPI: Avoid references to impossible processors.
In-Reply-To: <20071120124754.GB10127@Krystal>
Message-ID: <Pine.LNX.4.64.0711201214540.26419@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011331.944255657@sgi.com>
 <20071120124754.GB10127@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:

> > Convert one loop to NR_CPUS to use the cpu_possible map instead.
> > 
> 
> I'm just wondering how broken this is. Is there any assumption that
> there is no holes in the online cpu map in this code ?

Yeah, I saw only one loop in there and so I think this covers it. The 
debug code that I added to the cpu alloc patches did not throw any warning 
and bugs anymore. So I am sure that this does not occur on the 
configurations where I tested it. If some is running with the latest cpu 
area patches then he will get bugs() for accessing an impossible 
processors cpu area and warnings for accessing an offline processors cpu 
area.

