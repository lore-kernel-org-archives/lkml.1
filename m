Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYJOIin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYJOIin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYJOIif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:38:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYJOIie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:38:34 -0400
Date: Wed, 15 Oct 2008 04:38:11 -0400
From: Alan Cox <alan@redhat.com>
To: gyang <graf.yang@analog.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/6] Blackfin Serial Driver: Add a debug function to serial driver.
Message-ID: <20081015083811.GA21237@shell.devel.redhat.com>
References: <1223891185-13924-1-git-send-email-cooloney@kernel.org> <1223891185-13924-3-git-send-email-cooloney@kernel.org> <20081014142701.72090868@lxorguk.ukuu.org.uk> <1224037421.6284.40.camel@dyang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224037421.6284.40.camel@dyang>
User-Agent: Mutt/1.4.2.2i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:23:41AM +0800, gyang wrote:
> We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
> data cache flush function which will count it to a per-cpu counter.
> If this serial function is called too early, the per-cpu data area have
> not been initialized, this call will cause crash.
> So we'd like to use barrier() instead of cpu_relax().

Can you split that out as a separate change and include the explanation in
the patch then.

Thanks
Alan
