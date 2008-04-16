Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYDPTM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYDPTM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYDPTMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:12:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49225 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751599AbYDPTMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:12:21 -0400
Date: Wed, 16 Apr 2008 12:12:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Verify the page links and memory model
In-Reply-To: <20080416135138.1346.87095.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0804161211140.14635@schroedinger.engr.sgi.com>
References: <20080416135058.1346.65546.sendpatchset@skynet.skynet.ie>
 <20080416135138.1346.87095.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008, Mel Gorman wrote:

> +		FLAGS_RESERVED);

FLAGS_RESERVED no longer exists in mm. Its dynamically calculated.

It may be useful to print out NR_PAGEFLAGS instead and show the area in 
the middle of page flags that is left unused and that may be used by 
arches such as sparc64.

