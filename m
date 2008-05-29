Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYE2KK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYE2KK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYE2KKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:10:18 -0400
Received: from gw.goop.org ([64.81.55.164]:56121 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYE2KKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:10:17 -0400
Message-ID: <483E80E4.6030403@goop.org>
Date: Thu, 29 May 2008 11:09:40 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] Kill unused parameter to smp_call_function and friends
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> It bothers me how the smp call functions accept a 'nonatomic' or 'retry'
> parameter (depending on who you ask), but don't do anything with it.
> So kill that silly thing.
>
> Two patches here, one for smp_call_function*() and one for on_each_cpu().
> This patchset applies on top of the generic-ipi patchset just sent out.
>   

Yay!

Acked++-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
