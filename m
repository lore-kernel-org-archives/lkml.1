Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYLPRxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYLPRxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYLPRxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:53:12 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:18976 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYLPRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:53:11 -0500
Message-ID: <4947EB00.80507@oracle.com>
Date: Tue, 16 Dec 2008 09:53:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: mmotm 2008-12-16-00-43 uploaded (sparse irq)
References: <200812160847.mBG8lOrw019428@imap1.linux-foundation.org>
In-Reply-To: <200812160847.mBG8lOrw019428@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4947EAF0.00D9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-12-16-00-43 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc8:
> 
> irq-enclose-irq_desc_lock_class-in-config_sparse_irq.patch

whose patch is that?

If CONFIG_SPARSE_IRQ is not enabled, then builds fail with:

build-r7248.out:/local/linsrc/tmp/mmotm-2008-1216-0043/kernel/irq/handle.c:434: error: 'irq_desc_lock_class' undeclared (first use in this function)
build-r7248.out:make[3]: *** [kernel/irq/handle.o] Error 1


~Randy
