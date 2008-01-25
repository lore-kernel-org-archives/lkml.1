Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYAYDMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYAYDMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYAYDMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:12:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40670 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752215AbYAYDMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:12:43 -0500
Date: Thu, 24 Jan 2008 19:12:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Shaohua Li <shaohua.li@intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] some page can't be migrated
In-Reply-To: <1201230571.28282.2.camel@sli10-desk.sh.intel.com>
Message-ID: <Pine.LNX.4.64.0801241911470.31975@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com> 
 <200801251403.23236.nickpiggin@yahoo.com.au> <1201230571.28282.2.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Shaohua Li wrote:

> the page is still in lru list. Memory hot remove will try to migrate the
> page.

So this is an abandoned page with a refcount that only exists because of 
fs private data? Truncate race?

