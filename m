Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbXBLFTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbXBLFTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXBLFTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:19:30 -0500
Received: from 1wt.eu ([62.212.114.60]:2368 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992AbXBLFT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:19:29 -0500
Date: Mon, 12 Feb 2007 06:19:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212051924.GE13913@1wt.eu>
References: <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no> <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no> <fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no> <45CF60F2.5020308@shaw.ca> <20070211215211.GB13913@1wt.eu> <1171232786.4493.62.camel@nigel.suspend2.net> <20070211224637.GC13913@1wt.eu> <1171235922.4493.114.camel@nigel.suspend2.net> <20070211233822.GD13913@1wt.eu> <20070212002652.1ea4026e@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212002652.1ea4026e@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:26:52AM +0000, Alan wrote:
> > Unless I'm mistaken, I have to type the passphrase twice then :
> >   - once at suspend
> >   - once at resume
> > 
> > which is once more per "boot" than what I'm doing on loop-aes.
> 
> You don't need to type in a key at suspend time if you don't want to.
> Think about gpg email - I can send you an encrypted email without typing
> any keys, you need the right key however to read it.

OK, so that means that it can generate a random secret which is crypted
with your public key. That's very different from a crypted FS which has
to keep the same secret key over time for obvious reasons, but it is
smart to proceed this way.

One less "myth" as Nigel would say call it ;-)

Thanks Alan for clarifications
Willy

