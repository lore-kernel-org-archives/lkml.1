Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZCTPJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZCTPJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbZCTPJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:09:28 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:36409 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbZCTPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:09:27 -0400
Date: Fri, 20 Mar 2009 11:06:46 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/25] Calculate the preferred zone for allocation only
 once
In-Reply-To: <1237543392-11797-9-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903201105530.3740@qirst.com>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <1237543392-11797-9-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Mel Gorman wrote:

> get_page_from_freelist() can be called multiple times for an allocation.
> Part of this calculates the preferred_zone which is the first usable
> zone in the zonelist. This patch calculates preferred_zone once.

Isnt this adding an additional pass over the zonelist? Maybe mitigaged by
the first zone usually being the preferred zone.

