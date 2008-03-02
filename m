Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYCBTD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYCBTD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbYCBTDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:03:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYCBTDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:03:11 -0500
Subject: Re: HPL Benchmark performance degradation of kernel 2.6.24.3 vs
	2.6.23.14
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Allan Menezes <amenezes007@sympatico.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <47CAF675.7010305@cosmosbay.com>
References: <47CA3C60.8080402@sympatico.ca> <47CAF675.7010305@cosmosbay.com>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 20:02:56 +0100
Message-Id: <1204484576.6240.53.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-03-02 at 19:48 +0100, Eric Dumazet wrote:

> Examining your .config, I would point out CONFIG_SLUB_DEBUG=y
> You really should disable this expensive option.

CONFIG_SLUB_DEBUG_ON is the expensive one.

> (and possibly use CONFIG_SLAB instead of CONFIG_SLUB)

That is a good thing to test indeed.

