Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbXISSBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbXISSBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXISSAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:00:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54877 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131AbXISSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:00:54 -0400
Date: Wed, 19 Sep 2007 11:00:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       David Chinner <dgc@sgi.com>
Subject: Re: [RFC 13/26] SLUB: Add SlabReclaimable() to avoid repeated reclaim
 attempts
In-Reply-To: <46F13B6C.7020501@redhat.com>
Message-ID: <Pine.LNX.4.64.0709191100260.11882@schroedinger.engr.sgi.com>
References: <20070901014107.719506437@sgi.com> <20070901014222.303468369@sgi.com>
 <46F13B6C.7020501@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Rik van Riel wrote:

> Why is it safe to not use the normal page flag bit operators
> for these page flags operations?

Because SLUB always modifies page flags under PageLock.

