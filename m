Return-Path: <linux-kernel-owner+w=401wt.eu-S932494AbYARSfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbYARSfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764825AbYARSdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:33:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:46005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764580AbYARSdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:33:10 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: travis@sgi.com
Subject: Re: [PATCH 5/5] x86: Add debug of invalid per_cpu map accesses
Date: Fri, 18 Jan 2008 19:33:05 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080118183011.354965000@sgi.com> <20080118183012.050317000@sgi.com>
In-Reply-To: <20080118183012.050317000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181933.05662.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 19:30:16 travis@sgi.com wrote:
> Provide a means to trap usages of per_cpu map variables before
> they are setup.  Define CONFIG_DEBUG_PER_CPU_MAPS to activate.

Are you sure that debug option is generally useful enough
to merge? It seems very specific to your patchkit, but I'm not
sure it would be worth carrying forever in the kernel.

Better would be probably to just unmap those areas anyways.

-Andi
