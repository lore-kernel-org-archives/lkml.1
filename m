Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYE2Nr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYE2Nr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbYE2Nrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:47:46 -0400
Received: from gw.goop.org ([64.81.55.164]:41550 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbYE2Nrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:47:45 -0400
Message-ID: <483EB3DD.2090908@goop.org>
Date: Thu, 29 May 2008 14:47:09 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/10] x86: convert to generic helpers for IPI function
  calls
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-3-git-send-email-jens.axboe@oracle.com> <483E9D9B.9030202@goop.org> <20080529121704.GD25504@kernel.dk>
In-Reply-To: <20080529121704.GD25504@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> If you don't mind, I'd like to keep it as-is. Then the patch should
> not have a functional change (there, at least), which I think is
> important. I can add a later patch removing this stolen bit, it would
> be even better if you send me such a patch :-)
>   

Sure. BTW, I got it to mush on top of x86.git, and it seems OK.  There 
were lots of fairly trivial conflicts with things moving between unified 
files, and a few missing smp_call_function and on_each_cpu calls.

    J
