Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbXGFRt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbXGFRt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762127AbXGFRtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:49:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56074 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761982AbXGFRtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:49:05 -0400
Date: Fri, 6 Jul 2007 10:49:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/vmstat.c: possible cleanups
In-Reply-To: <20070705232345.GG3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707061048310.30575@schroedinger.engr.sgi.com>
References: <20070705232345.GG3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Adrian Bunk wrote:

> This patch contains the following possible cleanups:
> - make the needlessly global setup_vmstat() static

Ok.

> - #if 0 the unused refresh_vm_stats()

Hmmm... This may be needed by the cpu idle code to update the vm stats 
before going idle.
