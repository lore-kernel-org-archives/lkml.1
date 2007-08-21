Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbXHUUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbXHUUtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXHUUtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:49:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50723 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753148AbXHUUtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:49:03 -0400
Date: Tue, 21 Aug 2007 13:48:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
In-Reply-To: <1187692586.6114.211.camel@twins>
Message-ID: <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com> <1187692586.6114.211.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Peter Zijlstra wrote:

> This almost insta-OOMs with anonymous workloads.

What does the workload do? So writeout needs to begin earlier. There are 
likely issues with throttling.

