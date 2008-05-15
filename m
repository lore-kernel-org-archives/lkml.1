Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbYEOUZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbYEOUZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYEOUZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:25:07 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:17384 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYEOUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:25:04 -0400
Date: Thu, 15 May 2008 18:26:31 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080515152631.GG6778@il.ibm.com>
References: <87y76cym96.fsf@basil.nowhere.org> <20080515181619R.tomof@acm.org> <482C02A4.80101@firstfloor.org> <20080515184126O.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515184126O.tomof@acm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:41:26PM +0900, FUJITA Tomonori wrote:

> I thought that KVM people want to do it per device (in the first
> case). So with my patchse, they can replace the dma_ops pointer in
> dev_archdata with what they want.

That's my understanding too. We use stackable ops as a poor man's
replacement for per-device ops (depending on what kind of device it
is, call the original ops or our pvdma ops).

Cheers,
Muli



