Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbZKYLOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbZKYLOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZKYLOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:14:07 -0500
Received: from ozlabs.org ([203.10.76.45]:43873 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZKYLOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:14:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: percpu tree build warning
Date: Wed, 25 Nov 2009 21:44:08 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <20091125105004.GA18163@elte.hu>
In-Reply-To: <20091125105004.GA18163@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911252144.08686.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 09:20:04 pm Ingo Molnar wrote:
> If yes then that needs to be fixed in the percpu tree. per-cpu variables 
> used to have a __per_cpu prefix and that should be maintained - the two 
> namespaces are obviously separate on the logical space, so they should 
> never overlap in the implementational space either.

No, we've been through this.

sparse annotations replace the per_cpu prefix now per-cpu vars can be used
withn other than per-cpu ops (ie. their address can be usefully taken).

The prefix crutch predated sparse.  And it was certainly never supposed to
let people write confusing and crap code like this.

Rusty.
