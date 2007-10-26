Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbXJZDT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbXJZDT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbXJZDTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:19:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38780 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751992AbXJZDTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:19:50 -0400
Date: Thu, 25 Oct 2007 20:19:49 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/3] cpusets: memory_spread_user interleaves over all
 mems_allowed
Message-Id: <20071025201949.9df5f10d.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710251933490.2989@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251933490.2989@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> -			tmp = cpuset_mems_allowed(current);
> +			tmp = *newmask;

I see this as a nice little optimization, not a change in
what the code does.  That is, *newmask happens to already
hold cpuset_mems_allowed(current), so can be used for such.

Is that right?

If so, nice tweak - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
