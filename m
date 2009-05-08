Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZEHQnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZEHQnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZEHQm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:42:59 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:39290 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753758AbZEHQm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:42:58 -0400
Date: Fri, 8 May 2009 12:42:21 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rientjes@google.com
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
In-Reply-To: <1241800267.6311.2969.camel@laptop>
Message-ID: <alpine.DEB.1.10.0905081241530.15748@qirst.com>
References: <1241795429.28600.61.camel@penberg-laptop>  <alpine.DEB.1.10.0905081127240.26361@qirst.com>  <1241797017.28600.63.camel@penberg-laptop>  <1241797364.6311.2914.camel@laptop>  <1241797558.28600.68.camel@penberg-laptop>  <1241797858.6311.2925.camel@laptop>
  <20090508161553.GL6132@lenovo> <1241800267.6311.2969.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Peter Zijlstra wrote:

> Well, what I'm saying is that that either is a genuine bug we should
> fix, or its boot code, which is exactly what my assertion above tests
> for.
>
> I really believe GFP_PANIC usage outside of system_state ==
> STATE_BOOTING is a bug we should fix. Not create a better syntax for.

I agree.
