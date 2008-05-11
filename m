Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYEKKFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYEKKFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 06:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYEKKEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 06:04:51 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:59060 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYEKKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 06:04:50 -0400
Date: Sun, 11 May 2008 13:08:58 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: alexisb@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86 calgary: add fallback dma_ops]]
Message-ID: <20080511100858.GV7484@il.ibm.com>
References: <1210282820.6114.209.camel@alexis> <20080509081322J.tomof@acm.org> <1210290111.6114.214.camel@alexis> <20080509092313S.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509092313S.tomof@acm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 09:23:29AM +0900, FUJITA Tomonori wrote:

> Can we put a pointer to dma_ops in struct device (archdata) like
> POWER does? The way to setup and handle x86 IOMMUs seems to become
> hacky day by day.

Per-device dma-ops will be useful for KVM (for pass-through device
support) and IB as well.

Cheers,
Muli
