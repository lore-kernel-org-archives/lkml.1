Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYAHTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYAHTES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYAHTEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:04:06 -0500
Received: from relay2.sgi.com ([192.48.171.30]:56875 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750962AbYAHTEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:04:05 -0500
Date: Tue, 8 Jan 2008 11:04:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] percpu: Per cpu code simplification V3
In-Reply-To: <20080108090702.GB27671@elte.hu>
Message-ID: <Pine.LNX.4.64.0801081102450.2228@schroedinger.engr.sgi.com>
References: <20080108021142.585467000@sgi.com> <20080108090702.GB27671@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Ingo Molnar wrote:

> i had the patch below for v2, it's still needed (because i didnt apply 
> the s390/etc. bits), right?

Well the patch really should go through mm because it is a change that 
covers multiple arches. I think testing with this is fine. I think Mike 
has diffed this against Linus tree so this works but will now conflict 
with the modcopy patch already in mm.

