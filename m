Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbXEMUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbXEMUgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXEMUga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:36:30 -0400
Received: from usul.saidi.cx ([204.11.33.34]:50080 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754370AbXEMUga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:36:30 -0400
Message-ID: <464776C0.5020007@overt.org>
Date: Sun, 13 May 2007 13:36:16 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tobias Bengtsson <tobbe@tobbe.nu>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
References: <4639D927.4080406@tobbe.nu> <4646EE93.8090307@drzeus.cx>
In-Reply-To: <4646EE93.8090307@drzeus.cx>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-I-Got-Here: Yes
X-I-Got-Here: Yes3
Subject: Re: SDHCI issues on Ricoh in 2.6.20, 21 and 21-rc7-mm2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> 
> We could do some silly polling hack. It isn't clean, but it might get things
> somewhat working at least.

Tobias,

Pierre has asked me to take a look implementing this. My first question is whether
all card events are getting dropped on the floor, or just insertion ones. That is
to say, if you have the card inserted when you load the module (which you say
makes the card usable), does it correctly detect that the card is ejected when
you eject it?

If ejects are notified correctly, then we can make the polling less hacky by
disabling it while the card is inserted.

Thanks,

--phil
