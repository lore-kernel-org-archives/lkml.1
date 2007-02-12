Return-Path: <linux-kernel-owner+w=401wt.eu-S965384AbXBLUyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384AbXBLUyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965392AbXBLUyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:54:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44549 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965384AbXBLUyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:54:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 21:20:07 +0100
User-Agent: KMail/1.9.5
Cc: Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no> <20070212002652.1ea4026e@localhost.localdomain> <20070212051924.GE13913@1wt.eu>
In-Reply-To: <20070212051924.GE13913@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122120.08032.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 06:19, Willy Tarreau wrote:
> On Mon, Feb 12, 2007 at 12:26:52AM +0000, Alan wrote:
> > > Unless I'm mistaken, I have to type the passphrase twice then :
> > >   - once at suspend
> > >   - once at resume
> > > 
> > > which is once more per "boot" than what I'm doing on loop-aes.
> > 
> > You don't need to type in a key at suspend time if you don't want to.
> > Think about gpg email - I can send you an encrypted email without typing
> > any keys, you need the right key however to read it.
> 
> OK, so that means that it can generate a random secret which is crypted
> with your public key. That's very different from a crypted FS which has
> to keep the same secret key over time for obvious reasons, but it is
> smart to proceed this way.
> 
> One less "myth" as Nigel would say call it ;-)

Yup.  Our userland suspend tools available from http://suspend.sf.net are
capable of doing that in a more or less transparent way.

Greetings,
Rafael

