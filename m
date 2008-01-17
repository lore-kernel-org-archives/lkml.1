Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYAQSba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYAQSba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbYAQSbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:31:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbYAQSbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:31:20 -0500
Date: Thu, 17 Jan 2008 10:30:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, Eric Dumazet <dada1@cosmosbay.com>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Fixup NR-CPUS patch for numa
Message-Id: <20080117103000.5e97dcd2.akpm@linux-foundation.org>
In-Reply-To: <20080116183438.636758000@sgi.com>
References: <20080116183438.506737000@sgi.com>
	<20080116183438.636758000@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 10:34:39 -0800 travis@sgi.com wrote:

> This patch removes the EXPORT_SYMBOL for:
> 
> 	x86_cpu_to_node_map_init
> 	x86_cpu_to_node_map_early_ptr
> 
> ... thus fixing the section mismatch problem.

Which section mismatch problem?  Please always quote the error message when
fixing things like this.

> Also, the mem -> node hash lookup is fixed.
> 
> Based on 2.6.24-rc6-mm1 + change-NR_CPUS-V3 patchset
> 

hm, I've been hiding from those patches.

Are they ready?

