Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYGKMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYGKMyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYGKMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:54:06 -0400
Received: from bu3sch.de ([62.75.166.246]:55508 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYGKMyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:54:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
Date: Fri, 11 Jul 2008 14:53:19 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mchehab@infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
References: <200807101914.10174.mb@bu3sch.de> <487651CA.6030405@gmail.com> <200807101302.12765.david-b@pacbell.net>
In-Reply-To: <200807101302.12765.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111453.20162.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 22:02:12 David Brownell wrote:
> See Documentation/gpio.txt:
> 
> + Note that these operations include I/O barriers on platforms
> + which need to use them; drivers don't need to add them explicitly.
> 
> That's the key thing:  drivers using I/O calls should
> not need to insert bus or platform specific calls to
> make sure the calls take effect.


Well, as I said, I am OK with an I/O-barrier, which is mmiowb().
But flushing, by reading the register back, is not acceptable for
me in this case, unless someone can show me hardware that needs this.
And even then I'd implement the flushing only conditionally for
that hardware.

-- 
Greetings Michael.
