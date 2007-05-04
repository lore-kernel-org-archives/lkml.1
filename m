Return-Path: <linux-kernel-owner+w=401wt.eu-S1031434AbXEDVmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031434AbXEDVmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031711AbXEDVmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:42:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59043 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031434AbXEDVmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:42:04 -0400
Date: Fri, 4 May 2007 14:42:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
In-Reply-To: <20070504134212.c18d2d65.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705041439040.25764@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
 <20070504134212.c18d2d65.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Andrew Morton wrote:

> So the patch took the average system time from 4.42 seconds up to 4.582
> seconds.  Nice slowdown!

All of that from a memset and a list head init on a cacheline we already 
use?

