Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZK3QYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZK3QYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZK3QYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:24:18 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51595 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZK3QYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:24:17 -0500
Date: Mon, 30 Nov 2009 10:23:37 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for
 !CONFIG_PREEMPT kernels
In-Reply-To: <1259579114.20516.136.camel@laptop>
Message-ID: <alpine.DEB.2.00.0911301021490.14098@router.home>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>  <1258985167-29178-11-git-send-email-gleb@redhat.com>  <1258990455.4531.594.camel@laptop> <20091123155851.GU2999@redhat.com>  <alpine.DEB.2.00.0911231128190.785@router.home>  <20091124071250.GC2999@redhat.com>
  <alpine.DEB.2.00.0911240906360.14045@router.home>  <20091130105612.GF30150@redhat.com>  <20091130105812.GG30150@redhat.com>  <1259578793.20516.130.camel@laptop> <1259579114.20516.136.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok so there is some variance in tests as usual due to cacheline placement.
But it seems that overall we are looking at a 1-2% regression.

