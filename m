Return-Path: <linux-kernel-owner+w=401wt.eu-S965962AbXDBVoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965962AbXDBVoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965965AbXDBVoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:44:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965962AbXDBVoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:44:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=ajxRLaox+aYNScHuNPjxk0t3PWRqkpnrvG6WHLauEEZuHZWXcjgp+nZoCpYaMY8LR
	kE5YDB/+veTIbf+azPv2w==
Message-ID: <46117916.2040601@google.com>
Date: Mon, 02 Apr 2007 14:43:50 -0700
From: Martin Bligh <mbligh@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Dave Hansen <hansendc@us.ibm.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>  <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com>  <200704011246.52238.ak@suse.de>  <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com>  <1175544797.22373.62.camel@localhost.localdomain>  <Pine.LNX.4.64.0704021324480.31842@schroedinger.engr.sgi.com> <1175548086.22373.99.camel@localhost.localdomain> <Pine.LNX.4.64.0704021422040.2272@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704021422040.2272@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that these arguments on DISCONTIG are flame bait for many SGIers. 
> We usually see this as an attack on DISCONTIG/VMEMMAP which is the 
> existing best performing implementation for page_to_pfn and vice 
> versa. Please lets stop the polarization. We want one consistent scheme 
> to manage memory everywhere. I do not care what its called as long as it 
> covers all the bases and is not a glaring performance regresssion (like 
> SPARSEMEM so far).

The main conceptual difference (in my mind) was not having one
bastardized data structure (pg_data_t) that meant different
things in different situations (is it a node, or a section
of discontig mem?). Also we didn't support discontig mem within
a node (at least with the old discontigmem), which was partly
the result of that hybridization.

Beyond that, it's just naming really.

M.
