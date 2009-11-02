Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZKBJym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZKBJym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZKBJyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:54:41 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:14582 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZKBJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:54:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=D1Xh87GyK6waemJtc7pD4sjviTrhryRvcFTtW2KSoKBn/3W4OQjWF1b0GG5DyGp3Xs
         AOUYeaKBpyiCCHMwcrViisdZoOJm8RUFkJ2zgeoiRq8J5FnefvnNmZdCMzcuXtKVNB8J
         U1/GL2n3bEaB3+veh/ReT4TWioERS00WcntAg=
MIME-Version: 1.0
In-Reply-To: <20091102093840.GA11426@elf.ucw.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de> <20091101205449.GT14091@buzzloop.caiaq.de> 
	<20091101213343.GA31345@elf.ucw.cz> <20091101220341.GA16698@elf.ucw.cz> 
	<771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com> 
	<20091102093840.GA11426@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 2 Nov 2009 17:54:25 +0800
Message-ID: <f17812d70911020154n2f787a7bu907799b9f7f4e18a@mail.gmail.com>
Subject: Re: Possible suspend/resume regression in .32-rc?
To: Pavel Machek <pavel@ucw.cz>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, dsaxena@laptop.org,
       alan@linux.intel.com, gregkh@suse.de, Daniel Mack <daniel@caiaq.de>,
       linux-arm-kernel@lists.infradead.org,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The original patch is also poorly changelogged. What is the advantage
> of ICHP and why do we want default priorities?
>

That's going to simplify the "get_irqnr_and_base" macro significantly
and make it much easier to adopt pxa950 which has more than 64
IRQs. And besides, it's priority based, so we do want to handle IRQ
numbers from high priority to low from software either.
