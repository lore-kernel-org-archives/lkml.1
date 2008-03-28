Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbYC1Cmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbYC1Cmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbYC1Cly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:41:54 -0400
Received: from ozlabs.org ([203.10.76.45]:34826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbYC1Clx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:41:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 4 of 4] paravirt_ops: don't steal memory resources in paravirt_disable_iospace
Date: Fri, 28 Mar 2008 13:41:13 +1100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <9befcae155388f3f0e71.1206664120@localhost>
In-Reply-To: <9befcae155388f3f0e71.1206664120@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281341.14031.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008 11:28:40 Jeremy Fitzhardinge wrote:
> The memory resource is also used for main memory, and we need it to
> allocate physical addresses for memory hotplug.  Knobbling io space is
> enough to get the job done anyway.

Indeed, tested with lguest and it works for me.  I've put this in my 
patchqueue, but if it all gets taken by someone else I can easily drop it.

Thanks,
Rusty.
