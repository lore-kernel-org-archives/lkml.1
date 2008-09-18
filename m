Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYIRV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYIRV7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYIRV7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:59:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbYIRV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:59:11 -0400
Message-ID: <48D2CEF3.6060308@linux-foundation.org>
Date: Thu, 18 Sep 2008 16:58:11 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: MinChan Kim <minchan.kim@gmail.com>
CC: Martin Bligh <mbligh@google.com>, Chris Snook <csnook@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17A93.4000803@goop.org>	 <48D29AFB.5070409@linux-foundation.org> <48D2A392.6010308@goop.org>	 <33307c790809181352h14f2cf26kc73de75b939177b5@mail.gmail.com>	 <48D2BFB8.6010503@redhat.com>	 <33307c790809181411j41a6fc4ev8560a13ed8661ec2@mail.gmail.com>	 <48D2C46A.5030702@linux-foundation.org>	 <33307c790809181421k52ed6a36h9d4ee40d5799a536@mail.gmail.com>	 <48D2C8DD.4040303@linux-foundation.org> <28c262360809181449v1050c1f7ndf17dadba9fac0bf@mail.gmail.com>
In-Reply-To: <28c262360809181449v1050c1f7ndf17dadba9fac0bf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MinChan Kim wrote:

> In case of file-mapped pages, Shouldn't we use just on-demand
> readahead mechanism in kernel ?

Correct.

> If it is inefficient, It means we have to change on-demand readahead
> mechanism itself.

Right.

My patches were only for anonymous pages not for file backed because readahead
is available for file backed mappings.

