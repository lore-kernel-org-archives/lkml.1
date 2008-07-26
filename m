Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbYGZJKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbYGZJKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYGZJKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:10:05 -0400
Received: from il.qumranet.com ([212.179.150.194]:50620 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbYGZJKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:10:03 -0400
Message-ID: <488AE9E9.1020502@qumranet.com>
Date: Sat, 26 Jul 2008 12:10:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: kvm@vger.kernel.org, xiantao.zhang@intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH retry] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore
 in error handling code
References: <Pine.LNX.4.64.0807222137350.2670@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0807222137350.2670@ask.diku.dk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 26 Jul 2008 12:10:01 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> There is a call to local_irq_restore in the normal exit case, so it would
> seem that there should be one on an error return as well.
>
> The semantic patch that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

