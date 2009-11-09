Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZKIL0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZKIL0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZKIL0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:26:30 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33976 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbZKIL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:26:30 -0500
X-Sasl-enc: VvGvTWkjCuXqNY/RJNvQFOpyEQnTFR/KISAsS5jbyMqX 1257765994
Message-ID: <4AF7FC64.6030904@ladisch.de>
Date: Mon, 09 Nov 2009 12:26:28 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
References: <4AF7D439.4030305@ladisch.de>	<20091109091044.GX29442@buzzloop.caiaq.de>	<4AF7DDC1.4090006@ladisch.de> <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
In-Reply-To: <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Clemens Ladisch <clemens@ladisch.de> wrote:
> > Make the default console cursor type configurable rather than
> > hard-coding it.
> 
> You can set the cursor type at runtime so this all seems unjustified and
> doing this kind of thing at build time is definitely the wrong place.

The justification from Daniel's original patch was:
| For embedded systems, the blinking cursor at startup time can be
| annoying and unintended.

Would a simple "Disable cursor by default" switch more acceptable?


Clemens
