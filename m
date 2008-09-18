Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYIRWMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYIRWMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYIRWMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:12:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbYIRWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:12:31 -0400
Message-ID: <48D2D22B.2070408@linux-foundation.org>
Date: Thu, 18 Sep 2008 17:11:55 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: MinChan Kim <minchan.kim@gmail.com>, Chris Snook <csnook@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D2A392.6010308@goop.org>	 <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>	 <48D2BFB8.6010503@redhat.com>	 <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>	 <48D2C46A.5030702@linux-foundation.org>	 <33307c790809181421k52ed6a36h9d4ee40d5799a536@mail.gmail.com>	 <48D2C8DD.4040303@linux-foundation.org>	 <28c262360809181449v1050c1f7ndf17dadba9fac0bf@mail.gmail.com>	 <48D2CEF3.6060308@linux-foundation.org> <33307c790809181508v2e64c0a4j8f0e93df99673e63@mail.gmail.com>
In-Reply-To: <33307c790809181508v2e64c0a4j8f0e93df99673e63@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Bligh wrote:
>> My patches were only for anonymous pages not for file backed because readahead
>> is available for file backed mappings.
> 
> Do we populate the PTEs though? I didn't think that was batched, but I
> might well be wrong.

We do not populate the PTEs and AFAICT PTE population was assumed not to be
performance critical since the backing media is comparatively slow.

