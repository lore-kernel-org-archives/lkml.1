Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYIRVOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYIRVOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbYIRVOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:14:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099AbYIRVOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:14:14 -0400
Message-ID: <48D2C46A.5030702@linux-foundation.org>
Date: Thu, 18 Sep 2008 16:13:14 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: Chris Snook <csnook@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D1625C.7000309@redhat.com>	 <48D17A93.4000803@goop.org> <48D29AFB.5070409@linux-foundation.org>	 <48D2A392.6010308@goop.org>	 <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>	 <48D2BFB8.6010503@redhat.com> <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>
In-Reply-To: <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Bligh wrote:
>>> Yup, basically you're assuming good locality of reference, but it turns
>>> out that (as davej would say) "userspace sucks".
>> Well, *most* userspace sucks.  It might still be worthwhile to do this when
>> userspace is using madvise().
> 
> Quite possibly true ... something to benchmark.

Well, I guess we need a new binary format that allows one to execute binaries
in kernel address space with full powers.


