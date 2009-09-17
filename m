Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZIQQrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZIQQrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZIQQrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:47:09 -0400
Received: from claw.goop.org ([74.207.240.146]:37161 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbZIQQrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:47:08 -0400
Message-ID: <4AB2680E.9050005@goop.org>
Date: Thu, 17 Sep 2009 09:47:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Miroslav Rezanina <mrezanin@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to
 hypervisor
References: <1671727226.207651253175241980.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1671727226.207651253175241980.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/09 01:14, Miroslav Rezanina wrote:
> Hi Jeremy,
> I check your application. It won't work correctly. You are calling return_unused_memory in xen_memory_setup that is too soon.
> When you are calling it, there is no hole in map in any case. Calling should be in xen_post_allocator_init function (in arch/x86/xen/mmu.c).
>   

OK.  Where does the e820 map get changed in the meantime?

    J
