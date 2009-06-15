Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbZFOJSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbZFOJSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZFOJSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:18:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44197
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbZFOJSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:18:01 -0400
Date: Mon, 15 Jun 2009 02:18:04 -0700 (PDT)
Message-Id: <20090615.021804.133469642.davem@davemloft.net>
To: tiwai@suse.de
Cc: bzolnier@gmail.com, sven.koehler@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <s5h7hzdew6u.wl%tiwai@suse.de>
References: <s5hzlcedxqn.wl%tiwai@suse.de>
	<200906121344.26139.bzolnier@gmail.com>
	<s5h7hzdew6u.wl%tiwai@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Mon, 15 Jun 2009 10:30:01 +0200

> I think we should go back to basic.  The patch below cuts off the
> position compensation but falls back to the last value, which is a
> safer option.  How about this?

I'll give this a try in a few moments.
