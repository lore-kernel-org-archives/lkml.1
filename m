Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYLEVMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYLEVMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYLEVM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:12:28 -0500
Received: from broadrack.ru ([195.178.208.66]:33689 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbYLEVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:12:28 -0500
Date: Sat, 6 Dec 2008 00:12:23 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081205211223.GA8075@ioremap.net>
References: <20081205180350.GA25236@ioremap.net> <20081205181610.518ecd13@lxorguk.ukuu.org.uk> <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com> <20081205192755.GA27712@ioremap.net> <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 07:34:32PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > I can not run bisect, since reboot requires vnc and I'm far from fast
> > channel. Build of the fresh tree with existing config takes almost
> > one hour, but it should not be a major problem.
> > 
> > I can do bisection after the weekend, but can test some changes before
> > machine froze with unsuccessful patch.
> 
> I really have no idea what you are seeing so short of a bisect I've
> nothing to suggest.

But if things would be in userspace, then it should be fired long ago
with .27 kernel, no?

And what's with tty drivers? If kernel freezes there even if suddenly
faulty userspace started to load them, where this can happen? Apparently
it is not sleeping userspace since console does not respond to input.

-- 
	Evgeniy Polyakov
