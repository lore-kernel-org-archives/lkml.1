Return-Path: <linux-kernel-owner+w=401wt.eu-S1422966AbXCBG37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422966AbXCBG37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422967AbXCBG37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:29:59 -0500
Received: from gw.goop.org ([64.81.55.164]:37214 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422966AbXCBG37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:29:59 -0500
Message-ID: <45E7C466.1030006@goop.org>
Date: Thu, 01 Mar 2007 22:29:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com> <45E79529.9000305@goop.org> <45E79C72.4000806@goop.org> <45E7C306.4080400@vmware.com>
In-Reply-To: <45E7C306.4080400@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> That doesn't quite work, since we need to know which of the two -
> KM_PTE0 or KM_PTE1 is being mapped.  But it could be moved to before
> the mapping, as you need, and take this as a parameter. 

Err, kmap_atomic_pte gets passed the type - KM_PTE0 or KM_PTE1.

    J
