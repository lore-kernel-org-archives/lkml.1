Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYFBKEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYFBKEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYFBKEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:04:16 -0400
Received: from gw.goop.org ([64.81.55.164]:54196 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYFBKEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:04:15 -0400
Message-ID: <4843C578.6060201@goop.org>
Date: Mon, 02 Jun 2008 11:03:36 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       xen-devel <xen-devel@lists.xensource.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10 of 12] xen: implement save/restore
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost> <20080602092144.GA22955%yamahata@valinux.co.jp>
In-Reply-To: <20080602092144.GA22955%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> What is the purpose of load_cr3() here?
> I'd like to make this load_cr3() more arch generic for ia64 support.
> (or eliminate it if possible)
>   

I think it's an unnecessary left-over from when I was trying to get that 
stuff to work.  I can't think of a good reason not to just remove it if 
it causes you problems.

BTW, I tried to split the suspend/resume stuff into common and things 
which were definitely x86-specific with you in mind.  How close did I get?

    J
