Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZCJLlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZCJLlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZCJLkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:40:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39251 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbZCJLkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:40:51 -0400
Date: Tue, 10 Mar 2009 11:41:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: graff yang <graff.yang@gmail.com>, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       graf.yang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
Message-ID: <20090310114118.1ac5f3ea@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0903100429t22515ebav286eb9447fc41a93@mail.gmail.com>
References: <1236670166-3910-1-git-send-email-graff.yang@gmail.com>
	<8bd0f97a0903100103w6fc3dfc8se6076c98dbe5d8b4@mail.gmail.com>
	<7d86d44a0903100425y2ed41d72p3ec43021f554af96@mail.gmail.com>
	<8bd0f97a0903100429t22515ebav286eb9447fc41a93@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> i meant in terms of the user being notified it's a bogus value.  what
> if they did max_rate=576000 ?  clearly they meant 57600, but they hit
> "0" too many times ...

If a termios option is set which is not supported by the hardware the
driver should put the value it actually used in the termios struct.

Alan
