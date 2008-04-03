Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYDCM4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYDCM4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYDCM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:56:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46976 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753598AbYDCM4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:56:07 -0400
Date: Thu, 3 Apr 2008 07:56:01 -0500
From: Paul Jackson <pj@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       andi@firstfloor.org
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
Message-Id: <20080403075601.d86bc0bd.pj@sgi.com>
In-Reply-To: <47F44D25.6030001@jp.fujitsu.com>
References: <47F21BE3.5030705@jp.fujitsu.com>
	<20080401065534.a6267b96.pj@sgi.com>
	<47F34625.6000600@jp.fujitsu.com>
	<20080402061405.197c0c90.pj@sgi.com>
	<47F44D25.6030001@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.Seto wrote:
> So, if there is no one can find use of two flags, I'll change it to one.
> Comments from any others?

I too don't have a strong preference either way ... just a bias toward
keeping the exposed per-cpuset flags as simple and generic as practical.

Exposing internal details that don't need to be exposed has two downsides:
 1) it makes using the flags slightly more difficult, as the user has to
    figure out more details, and
 2) it exposes some internal details that we didn't need to expose, thereby
    possibly making future changes more difficult.  We can change internal
    hidden detail anytime we want, but exposed interfaces are locked in
    with a high barrier to incompatible change.

I too would welcome comments from others.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
