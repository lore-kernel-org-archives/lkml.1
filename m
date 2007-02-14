Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbXBNBhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbXBNBhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbXBNBhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:37:46 -0500
Received: from gw.goop.org ([64.81.55.164]:43066 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbXBNBhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:37:46 -0500
Message-ID: <45D267E8.7090506@goop.org>
Date: Tue, 13 Feb 2007 17:37:44 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 10/21] Xen-paravirt: Name: dont export paravirt_ops structure,
 do individual functions
References: <20070213221729.772002682@goop.org> <20070213221830.238235953@goop.org> <45D260A2.4010200@vmware.com> <45D262DC.2020008@goop.org> <45D2635D.9070205@vmware.com>
In-Reply-To: <45D2635D.9070205@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Ok.  As long as we plan on patching CR2 and CR0 / clts accessors for
> FPU save during context switch and page fault paths in the future.

That's up to each backend, right?  Or do these need to be patched for a
correctness reason?

    J

