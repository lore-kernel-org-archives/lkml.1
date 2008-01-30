Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYA3C7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYA3C7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYA3C71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:59:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:36792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbYA3C70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:59:26 -0500
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and bootmap
Date: Wed, 30 Jan 2008 03:57:54 +0100
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200801291113.35974.yinghai.lu@sun.com> <200801291116.31729.yinghai.lu@sun.com>
In-Reply-To: <200801291116.31729.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801300357.54924.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 20:16, Yinghai Lu wrote:
> [PATCH 4/4] x86_64: increse MAX_EARLY_RES for NODE_DATA and bootmap
>
> otherise early_node_mem will use up these for 8 nodes system

Yes this was the problem with my early_reserve node bootmem patch.
It adds a node limit.

But even with increasing the limit is far too small. Probably best to not 
use the patch. In theory it should not have been needed anyways because
there is no need to reserve here because there are no interfering users.

Whatever your problem is it needs to be solved differently.

-Andi


