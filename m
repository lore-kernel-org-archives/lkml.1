Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYAYDJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYAYDJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYAYDJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:09:27 -0500
Received: from relay2.sgi.com ([192.48.171.30]:51143 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752271AbYAYDJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:09:26 -0500
Date: Thu, 24 Jan 2008 19:09:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] some page can't be migrated
In-Reply-To: <200801251403.23236.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0801241908370.31942@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
 <200801251403.23236.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Nick Piggin wrote:

> On Wednesday 23 January 2008 17:22, Shaohua Li wrote:
> > Anonymous page might have fs-private metadata, the page is truncated. As
> > the page hasn't mapping, page migration refuse to migrate the page. It
> > appears the page is only freed in page reclaim and if zone watermark is
> > low, the page is never freed, as a result migration always fail. I
> > thought we could free the metadata so such page can be freed in
> > migration and make migration more reliable?
> 
> Anonymous pages should not have fs-private metadata.
> 
> Orphaned pages I guess you mean? They should not be accessable via
> the pagecache or the page tables, so how do they keep tangling up
> migration? Where/how is migration finding these pages?!

Is this maybe related to memory unplug or some such project?

