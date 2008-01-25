Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYAYEmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYAYEmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 23:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYAYEmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 23:42:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42601 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbYAYEmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 23:42:43 -0500
Date: Thu, 24 Jan 2008 20:42:41 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Shaohua Li <shaohua.li@intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] some page can't be migrated
In-Reply-To: <200801251517.02287.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0801242041270.5960@schroedinger.engr.sgi.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
 <1201233590.28282.13.camel@sli10-desk.sh.intel.com>
 <Pine.LNX.4.64.0801242000320.1932@schroedinger.engr.sgi.com>
 <200801251517.02287.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Nick Piggin wrote:

> Yeah, for memory hot remove that makes sense. A comment
> might be in order, at least a reference to the orphaned
> page code in vmscan.c.

Right. The surrounding comments in mm/migrate.c also need to be made 
consistent. The comment before is now slightly off. Could you do another 
patch Shaohua with better comments?
