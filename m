Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbXKAPo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbXKAPo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXKAPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:44:20 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:55112
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXKAPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:44:19 -0400
X-Greylist: delayed 7779 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 11:44:18 EDT
Message-ID: <4729E3F3.2090602@microgate.com>
Date: Thu, 01 Nov 2007 08:34:27 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Char: tty, add tty_schedule_wakeup
References: <15530290543226725036.slaby@karneval.cz>
In-Reply-To: <15530290543226725036.slaby@karneval.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> + *	Functionally the same as tty_wakeup, but it can be used in hot
> + *	paths. since the wakeup is scheduled and done in the future.
> 

I'm not familiar with the terminology 'hot paths',
what do you mean by that?

Do you have an example of where you intend to
use this new facility? The patch does not include
such an example so it is difficult for me to see
why you are adding this function.

--
Paul Fulghum
Microgate Systems, Ltd
