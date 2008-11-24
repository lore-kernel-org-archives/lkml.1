Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYKXTQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYKXTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYKXTQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:16:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYKXTQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:16:47 -0500
Subject: Re: [patch 1/2] mm: change dirty limit type specifiers to unsigned
 long
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Nov 2008 20:16:41 +0100
Message-Id: <1227554201.4259.538.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-23 at 10:55 -0800, David Rientjes wrote:
> The background dirty and dirty limits are better defined with type
> specifiers of unsigned long since negative writeback thresholds are not
> possible.
> 
> These values, as returned by get_dirty_limits(), are normally compared
> with ZVC values to determine whether writeback shall commence or be
> throttled.  Such page counts cannot be negative, so declaring the page
> limits as signed is unnecessary.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

This didn't pop up any weird and wonderfull assumptions on the
signed-ness of these variables I take it :-)


Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
