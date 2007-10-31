Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXJaPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXJaPH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbXJaPHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:07:51 -0400
Received: from gw.goop.org ([64.81.55.164]:36716 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678AbXJaPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:07:50 -0400
Message-ID: <47289A3F.4040608@goop.org>
Date: Wed, 31 Oct 2007 08:07:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: tgh <wwwwww4187@sina.com.cn>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Xen-devel] [patch 30/44] xen: Add support for preemption
References: <20070716231536.937393000@xensource.com>>	<20070716232915.672717000@xensource.com>>	<4726F51C.4030709@sina.com.cn>	<4727690F.4030502@goop.org> <4727D926.6050004@sina.com.cn> <4727DC88.2020803@goop.org> <47281C75.4040106@sina.com.cn>
In-Reply-To: <47281C75.4040106@sina.com.cn>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tgh wrote:
> Thank you for your reply
> and what about the kernel thread in the xen hypervisor,are there some
> instance of kernel threads running in the hypervisor?
> I am not sure ,but somewhere I read that there is no kernel thread in
> the xen hypervisor ,is it true or what about it?
>   

No, there are no linux kernel threads in the hypervisor. The only
thread-like thing Xen has is a virtual CPU, and they're always guest
domain vcpus.

J
