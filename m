Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbYEOWBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbYEOWBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYEOWBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:01:04 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:5129 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYEOWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:01:03 -0400
Date: Fri, 16 May 2008 01:05:26 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080515220526.GH10434@il.ibm.com>
References: <87y76cym96.fsf@basil.nowhere.org> <20080515181619R.tomof@acm.org> <482C02A4.80101@firstfloor.org> <20080515184126O.tomof@acm.org> <20080515152631.GG6778@il.ibm.com> <20080515210340.GC318@one.firstfloor.org> <20080515213946.GE10434@il.ibm.com> <482CAEE6.5080509@firstfloor.org> <20080515215315.GG10434@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515215315.GG10434@il.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 12:53:15AM +0300, Muli Ben-Yehuda wrote:
> On Thu, May 15, 2008 at 11:45:10PM +0200, Andi Kleen wrote:
> 
> > Even rare cases need to be handled.
> 
> Sure, but I'd rather we handle the common case first.

... which is not to say of course we can't do both, dev_archdata could
have a list of struct dma_mapping_ops instead of (or in addition to) a
struct dma_mapping_ops pointer. If space was at a premium we could
even multiplex both on the same pointer by using one of the low bits
to select between them.

Cheers,
Muli
