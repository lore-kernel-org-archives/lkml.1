Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZKWRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZKWRar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZKWRaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:30:46 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:50900 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZKWRaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:30:46 -0500
Date: Mon, 23 Nov 2009 11:30:02 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Gleb Natapov <gleb@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for
 !CONFIG_PREEMPT kernels
In-Reply-To: <20091123155851.GU2999@redhat.com>
Message-ID: <alpine.DEB.2.00.0911231128190.785@router.home>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com> <1258985167-29178-11-git-send-email-gleb@redhat.com> <1258990455.4531.594.camel@laptop> <20091123155851.GU2999@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds significant overhead for the !PREEMPT case adding lots of code
in critical paths all over the place.


