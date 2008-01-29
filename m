Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYA2UOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYA2UOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbYA2UOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:14:00 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43079 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755887AbYA2UN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:13:59 -0500
Date: Tue, 29 Jan 2008 12:13:51 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, jeremy@goop.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] percpu: Optimize percpu accesses
In-Reply-To: <479F85F9.3040104@sgi.com>
Message-ID: <Pine.LNX.4.64.0801291213190.25468@schroedinger.engr.sgi.com>
References: <20080123044924.508382000@sgi.com> <20080124224613.GA24855@elte.hu>
 <479F85F9.3040104@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Mike Travis wrote:

> Since the zero-based patch is changing the offset from one based on
> __per_cpu_start to zero, it's causing the function to access a
> different area.

Looks like we just need to set the offset used for 0 to 
__per_cpu_start during early boot.
