Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYGDN3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYGDN3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758335AbYGDN2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:28:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45133 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135AbYGDN2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:28:50 -0400
Message-ID: <486E2589.8090304@garzik.org>
Date: Fri, 04 Jul 2008 09:28:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Takashi Iwai <tiwai@suse.de>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>	 <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <486CC440.9030909@garzik.org>	 <Pine.LNX.4.64.0807031353030.11033@blonde.site>	 <s5hmykxc3ja.wl%tiwai@suse.de> <1215177471.10393.753.camel@pmac.infradead.org>
In-Reply-To: <1215177471.10393.753.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> 3. Look at making 'make modules_install' installl the firmware required
>    by the modules it's installing, so you don't even need to do
>    _anything_ new.


Anything that works with existing build processes would be a positive 
step, preventing loads of build&test regressions.

This does not change the need, of course, to default this firmware 
install stuff to 'off', and allow distros to turn it on when they're 
ready (as Alan, Ted, and others have suggested in this thread).

	Jeff



