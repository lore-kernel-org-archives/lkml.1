Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbZKXHN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbZKXHN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZKXHN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:13:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbZKXHN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:13:28 -0500
Date: Tue, 24 Nov 2009 09:12:50 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for
 !CONFIG_PREEMPT kernels
Message-ID: <20091124071250.GC2999@redhat.com>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>
 <1258985167-29178-11-git-send-email-gleb@redhat.com>
 <1258990455.4531.594.camel@laptop>
 <20091123155851.GU2999@redhat.com>
 <alpine.DEB.2.00.0911231128190.785@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911231128190.785@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 11:30:02AM -0600, Christoph Lameter wrote:
> This adds significant overhead for the !PREEMPT case adding lots of code
> in critical paths all over the place.
> 
> 
I want to measure it. Can you suggest benchmarks to try?

--
			Gleb.
