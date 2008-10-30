Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYJ3QrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYJ3QrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbYJ3QrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:47:10 -0400
Received: from waste.org ([66.93.16.53]:58440 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbYJ3QrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:47:09 -0400
Subject: Re: [PATCH] regression: vmalloc easily fail.
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       aliguori@codemonkey.ws, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
In-Reply-To: <20081030044941.GA9470@wotan.suse.de>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com>
	 <20081028232944.GA3759@wotan.suse.de>
	 <20081029094856.GD4269@poweredge.glommer>
	 <20081029101145.GB5953@wotan.suse.de> <49083B14.6070402@redhat.com>
	 <20081029104333.GD5953@wotan.suse.de>
	 <20081029220737.GF11532@poweredge.glommer>
	 <20081030044941.GA9470@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 11:46:02 -0500
Message-Id: <1225385162.23508.33.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 05:49 +0100, Nick Piggin wrote:
> I still think we should get rid of the guard pages in non-debug kernels
> completely,

For what it's worth, I agree.

-- 
Mathematics is the supreme nostalgia of our time.

