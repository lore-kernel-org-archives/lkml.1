Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZDVRrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZDVRrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZDVRrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:47:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49604 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZDVRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:47:11 -0400
Subject: Re: [PATCH 18/22] Use allocation flags as an index to the zone
	watermark
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090422171451.GG15367@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-19-git-send-email-mel@csn.ul.ie>
	 <1240420313.10627.85.camel@nimitz>  <20090422171451.GG15367@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 10:47:03 -0700
Message-Id: <1240422423.10627.96.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 18:14 +0100, Mel Gorman wrote:
> Preference of taste really. When I started a conversion to accessors, it
> changed something recognised to something new that looked uglier to me.
> Only one place cares about the union enough to access is via an array so
> why spread it everywhere.

Personally, I'd say for consistency.  Someone looking at both forms
wouldn't necessarily know that they refer to the same variables unless
they know about the union.

