Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbXISRZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbXISRZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbXISRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:25:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51156 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944AbXISRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:25:07 -0400
Date: Wed, 19 Sep 2007 10:25:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Badari Pulavarty <pbadari@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc6-mm1 panic (memory controller issue ?)
In-Reply-To: <46F08135.70401@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0709191024440.11138@schroedinger.engr.sgi.com>
References: <1190154076.31220.19.camel@dyn9047017100.beaverton.ibm.com>
 <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com>
 <46F08135.70401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Balbir Singh wrote:

> The fix looks correct, radix_tree_preload() does the same thing in
> add_to_page_cache(). Thanks for identifying the fix

Hmmm.... Radix tree preload can only take a limited set of flags?

