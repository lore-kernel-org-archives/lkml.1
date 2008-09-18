Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYIRWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYIRWXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYIRWXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:23:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56731 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbYIRWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:23:05 -0400
Date: Fri, 19 Sep 2008 07:21:34 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Populating multiple ptes at fault time
Cc: kosaki.motohiro@jp.fujitsu.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Snook <csnook@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, "Martin J. Bligh" <mbligh@google.com>
In-Reply-To: <48D2AE6C.7060507@linux-foundation.org>
References: <48D2A392.6010308@goop.org> <48D2AE6C.7060507@linux-foundation.org>
Message-Id: <20080920191928.50ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeremy Fitzhardinge wrote:
> > Thanks, that was exactly what I was hoping to see.  I didn't see any
> > definitive statements against the patch set, other than a concern that
> > it could make things worse.  Was the upshot that no consensus was
> > reached about how to detect when its beneficial to preallocate anonymous
> > pages?
> 
> There were multiple discussions on the subject. The consensus was that it was
> difficult to generalize this and it would only work on special loads. Plus it
> would add some overhead to the general case.

but at that time, x86_64 large server doesn't exist yet.
I think mesurement again is valuable because typical server environment
is changed in these days.



