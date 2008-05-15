Return-Path: <linux-kernel-owner+w=401wt.eu-S1764858AbYEOU0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764858AbYEOU0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762356AbYEOUZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:25:35 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:31743 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761638AbYEOUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:25:31 -0400
Date: Thu, 15 May 2008 18:32:54 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080515153254.GI6778@il.ibm.com>
References: <87y76cym96.fsf@basil.nowhere.org> <20080515181619R.tomof@acm.org> <482C02A4.80101@firstfloor.org> <20080515184126O.tomof@acm.org> <482C14E4.9050201@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C14E4.9050201@firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:48:04PM +0200, Andi Kleen wrote:
> 
> > I thought that KVM people want to do it per device (in the first
> > case). So with my patchse, they can replace the dma_ops pointer in
> > dev_archdata with what they want.
> 
> But where would they save the original pointer?

See my other mail on this subject, we don't need the original pointer,
we just use stackable ops as a poor man's replacement for per-device
ops.

Cheers,
Muli
