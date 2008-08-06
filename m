Return-Path: <linux-kernel-owner+w=401wt.eu-S1762062AbYHFUfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062AbYHFUfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbYHFUfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:35:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50293 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbYHFUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:35:09 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5372389"
Message-ID: <489A0AFB.1030701@qualcomm.com>
Date: Wed, 06 Aug 2008 13:35:07 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Peter Oruba <peter.oruba@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/5] x86-microcode: run ucode update via workqueue
References: <20080806152117.198754464@amd.com> <b647ffbd0808061314n3bbe3396ncf0844cceb2576ac@mail.gmail.com>
In-Reply-To: <b647ffbd0808061314n3bbe3396ncf0844cceb2576ac@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> Hi Peter,
> 
>> Rebased Dmitry's patch set to x86-microcode and incorporated changes into AMD microcode patch loader. No issues with
>> cpu-hotplug anymore, tested on Intel as well as AMD.
> 
> btw., I still think we should consider running ucode-updates from the
> low-level arch code. But as it's perhaps a material for .28, there
> should be plenty of time. 

That'd be ok. Somehow I think it's not worth the effort though. If the 
machine was able to boot to the point that it can run user-space 
(request_firmware) with the old microcode it can probably sustain itself 
a bit longer while waiting for the workqueue thread to be scheduled.
You probably have more exciting things to do ;-)

The latest patches look ok btw.

Max

