Return-Path: <linux-kernel-owner+w=401wt.eu-S1764920AbYARSzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764920AbYARSzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYARSzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:55:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33502 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755886AbYARSy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:54:59 -0500
Date: Fri, 18 Jan 2008 10:54:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: Reduce memory and intra-node effects with large
 count NR_CPUs fixup
In-Reply-To: <4790A29F.9000006@sgi.com>
Message-ID: <Pine.LNX.4.64.0801181054180.30775@schroedinger.engr.sgi.com>
References: <20080117223546.419383000@sgi.com> <478FD9D9.7030009@sgi.com>
 <20080118092352.GH24337@elte.hu> <4790A29F.9000006@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Mike Travis wrote:

 > I hadn't considered doing 32-bit NUMA changes as I didn't know if the
> NR_CPUS count would really be increased for the 32-bit architecture.
> I have been trying though not to break it. ;-)

32bit NUMA is tricky because ZONE_NORMAL memory is only available on node 
0. There have been thorny difficult to debug issues in the past...


