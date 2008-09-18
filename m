Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYIRTkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYIRTkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYIRTj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:39:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbYIRTjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:39:55 -0400
Message-ID: <48D2AE6C.7060507@linux-foundation.org>
Date: Thu, 18 Sep 2008 14:39:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Snook <csnook@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, "Martin J. Bligh" <mbligh@google.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D1625C.7000309@redhat.com> <48D17A93.4000803@goop.org> <48D29AFB.5070409@linux-foundation.org> <48D2A392.6010308@goop.org>
In-Reply-To: <48D2A392.6010308@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Thanks, that was exactly what I was hoping to see.  I didn't see any
> definitive statements against the patch set, other than a concern that
> it could make things worse.  Was the upshot that no consensus was
> reached about how to detect when its beneficial to preallocate anonymous
> pages?

There were multiple discussions on the subject. The consensus was that it was
difficult to generalize this and it would only work on special loads. Plus it
would add some overhead to the general case.

> Christoph (and others): do you think vm changes in the last 4 years
> would have changed the outcome of these results?

Seems that the code today is similar. So it would still work.
