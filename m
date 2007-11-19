Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbXKSTo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbXKSTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXKSToW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:44:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50607 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXKSToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:44:21 -0500
Subject: Re: [RFC 5/7] LTTng instrumentation mm
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071119190040.GA1609@Krystal>
References: <20071113193349.214098508@polymtl.ca>
	 <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost>
	 <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost>
	 <20071116144742.GA17255@Krystal> <1195495626.27759.119.camel@localhost>
	 <20071119185258.GA998@Krystal>  <20071119190040.GA1609@Krystal>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 11:43:58 -0800
Message-Id: <1195501438.27759.130.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 14:00 -0500, Mathieu Desnoyers wrote:
> > Well, using page_to_pfn turns out to be ugly in markers (and in
> > printks) then. Depending on the architecture, it will result in either
> > an unsigned long (x86_64) or an unsigned int (i386), which corresponds
> 
> Well, it's signed long and signed int, but the point is still valid. 

the result of page_to_pfn() may end up being signed in practice, but it
never needs to be.  Just cast it to an unsigned long and make it
consistent everywhere.  

-- Dave

