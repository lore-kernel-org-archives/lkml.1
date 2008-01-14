Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYANKEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYANKEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYANKE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:04:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbYANKEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:04:25 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with large count NR_CPUs
Date: Mon, 14 Jan 2008 11:04:18 +0100
User-Agent: KMail/1.9.6
Cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20080113183453.973425000@sgi.com> <20080114081418.GB18296@elte.hu>
In-Reply-To: <20080114081418.GB18296@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141104.18789.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> i.e. we've got ~22K bloat per CPU - which is not bad, but because it's a 
> static component, it hurts smaller boxes. For distributors to enable 
> CONFIG_NR_CPU=1024 by default i guess that bloat has to drop below 1-2K 
> per CPU :-/ [that would still mean 1-2MB total bloat but that's much 
> more acceptable than 23MB]

Even 1-2MB overhead would be too much for distributors I think. Ideally
there must be near zero overhead for possible CPUs (and I see no principle
reason why this is not possible) Worst case a low few hundred KBs, but even
that would be much.

There are the cpusets which get passed around, but these are only one bit per 
possible CPU.

-Andi
