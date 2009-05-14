Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZENL2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZENL2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZENL2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:28:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZENL2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:28:31 -0400
Subject: Re: [PATCH] Physical Memory Management [0/1]
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
In-Reply-To: <op.utwwmpsf7p4s8u@amdc030>
References: <op.utu26hq77p4s8u@amdc030>
	 <20090513151142.5d166b92.akpm@linux-foundation.org>
	 <op.utwwmpsf7p4s8u@amdc030>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 May 2009 13:20:02 +0200
Message-Id: <1242300002.6642.1091.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 11:00 +0200, Michał Nazarewicz wrote:
>   PMM solves this problem since the buffers are allocated when they
>   are needed.

Ha - only when you actually manage to allocate things. Physically
contiguous allocations are exceedingly hard once the machine has been
running for a while.

