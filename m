Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYCZTSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYCZTSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYCZTSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:18:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56244 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752681AbYCZTSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:18:38 -0400
Date: Wed, 26 Mar 2008 12:16:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Modify Kconfig to allow up to 4096 cpus
In-Reply-To: <47EA7A5A.5030207@sgi.com>
Message-ID: <Pine.LNX.4.64.0803261215320.31000@schroedinger.engr.sgi.com>
References: <20080326014137.934171000@polaris-admin.engr.sgi.com>
 <20080326014138.292294000@polaris-admin.engr.sgi.com>
 <20080326160924.GC1789@cs181133002.pp.htv.fi> <47EA7A5A.5030207@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Mike Travis wrote:

> I guess the main effect is that "MAXSMP" represents what's really
> usable for an architecture based on other factors.  The limit of
> NODES_SHIFT = 15 is that it's represented in some places as a signed
> 16-bit value, so 15 is the hard limit without coding changes, not
> an architecture limit.

NODES_SHIFT also controls how many page flag bits are set aside for the 
node number. If you limit x86_64 to 512 nodes then lets keep this at 9.
