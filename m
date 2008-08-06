Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbYHFU3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbYHFU3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbYHFU3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:29:14 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030266AbYHFU3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:29:12 -0400
Date: Wed, 6 Aug 2008 15:29:10 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080806152910.9e4f76a2.pj@sgi.com>
In-Reply-To: <489A079E.5040903@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080802063900.6615e5ca.pj@sgi.com>
	<48948C3A.6050805@qualcomm.com>
	<20080802225127.2b0d138b.pj@sgi.com>
	<4895F3ED.4020805@qualcomm.com>
	<20080804010033.0d1b0549.pj@sgi.com>
	<48977E81.4040207@qualcomm.com>
	<20080804225636.541527e8.pj@sgi.com>
	<4898B873.6000308@qualcomm.com>
	<20080805180521.be7010e1.pj@sgi.com>
	<48991973.90109@qualcomm.com>
	<20080805222927.6dd95f5f.pj@sgi.com>
	<4899202B.6030303@qualcomm.com>
	<20080805232856.78dd50f7.pj@sgi.com>
	<489930B5.9030906@qualcomm.com>
	<20080806004629.d321f3b0.pj@sgi.com>
	<489A079E.5040903@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> Sure. That looks fine. Although inline_ will probably be a bit confusing 
> since one may think that it has something to do with the C 'inline'.
> I'd suggest either sync_rebuild_sched_domains() or simply 
> rebuild_sched_domains().

Good point about "inline" confusions.

I am willing to agree to "sync_rebuild_sched_domains()".

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
