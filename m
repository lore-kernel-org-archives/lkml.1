Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYAIERX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYAIERX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYAIERQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:17:16 -0500
Received: from ns.suse.de ([195.135.220.2]:58487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYAIERP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:17:15 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other achitectures and kill notifier cruft"
Date: Wed, 9 Jan 2008 05:17:11 +0100
User-Agent: KMail/1.9.6
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org, hch@lst.de,
       pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie> <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie> <20080108192951.a4dc394f.akpm@linux-foundation.org>
In-Reply-To: <20080108192951.a4dc394f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801090517.11410.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> An alternative might be to come up with something decent and target 2.6.24.x

If you want zero cache line cost the only way is to handle that using Mathieu's 
inline patch infrastructure. Having a generic notifier type based on that would be 
probably a good idea.

-Andi
