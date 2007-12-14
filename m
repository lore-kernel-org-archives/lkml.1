Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbXLNTCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbXLNTCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbXLNTCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:02:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbXLNTCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:02:22 -0500
Message-ID: <4762D322.2060101@zytor.com>
Date: Fri, 14 Dec 2007 11:01:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiri Slaby <jirislaby@gmail.com>, Arun Thomas <arun.thomas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>  <20071214015315.09829a99.akpm@linux-foundation.org> <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com> <4762586F.8090603@gmail.com> <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
> The problem is caused by an SMI during the calibration routine. We
> really need to come up with a solid solution which does not rely on
> the periodic timer coming in, when there is something else (HPET,
> pm_timer) available.
> 
> I have a look into this.
> 
> Arun, do you have an USB keyboard plugged in ? If not, can you connect
> one and check, whether it changes things or not ?
> 

How long is the SMI?

	-hpa
