Return-Path: <linux-kernel-owner+w=401wt.eu-S1751396AbXBMWtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbXBMWtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXBMWtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:49:14 -0500
Received: from gw.goop.org ([64.81.55.164]:33722 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXBMWtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:49:13 -0500
Message-ID: <45D24066.4070109@goop.org>
Date: Tue, 13 Feb 2007 14:49:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 13/21] Xen-paravirt: Add nosegneg capability to the vsyscall
 page notes
References: <20070213221729.772002682@goop.org> <20070213221830.466651996@goop.org> <45D23F97.5040907@vmware.com>
In-Reply-To: <45D23F97.5040907@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I don't like this because now a kernel compiled with both CONFIG_XEN
> and CONFIG_VMI has "nosegneg" turned on.  We don't actually require
> this for performance or correctness, so it would be nice to be able to
> dynamically turn it off instead of having it forced. 

Any suggestions about how to do this?  It seems hard to have a note
dynamically appear and disappear in the vsyscall.so.

I wasn't terribly concerned about this, since there is effectively zero
performance difference between the two library implementations.

    J
