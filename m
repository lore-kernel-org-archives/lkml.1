Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbXBOFgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbXBOFgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXBOFgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:36:00 -0500
Received: from mx1.suse.de ([195.135.220.2]:38647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXBOFf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:35:59 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 21:35:40 -0800
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org> <20070215041345.GA15654@redhat.com>
In-Reply-To: <20070215041345.GA15654@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702142135.40832.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 20:13, Dave Jones wrote:
> I've not investigated it, but I hear rumours that suse has something
> similar.

Actually, no. We don't belive that module signing adds significant value, and 
it also doesn't work well with external modules. (The external modules we 
really care about are GPL ones; it gives us a way to update drivers without 
pushing out entirely new kernels.)

Cheers,
Andreas
