Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYHFOLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYHFOLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYHFOLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:11:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:25459 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYHFOLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=kcl90t5t4PLEkEMmDHOngGCLkqbvQx/dhe9JS7WhVwGkDwKNn5Q2R2tExw6+BH7jb5
         J7RIojZ1gjRKIvfWu3tSVWLvITvqCtQlEsd5LWEGTP9EcarYYMBLlU98m/rVsCG9/9F5
         /ywvjnb251Q3Zd4Inonr9SrcO3Cszu92dI1wc=
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [GIT]: Networking
Date: Wed, 6 Aug 2008 16:35:04 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080805.190020.244441681.davem@davemloft.net> <200808061022.02432.IvDoorn@gmail.com> <20080806131503.GD7036@tuxdriver.com>
In-Reply-To: <20080806131503.GD7036@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061635.05292.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, John W. Linville wrote:
> On Wed, Aug 06, 2008 at 10:22:02AM +0200, Ivo van Doorn wrote:
> > On Wednesday 06 August 2008, Linus Torvalds wrote:
> 
> > > Well, it's also trying to support both 2.4.x and 2.6 etc. Yeah, that is 
> > > horrid. At the same time, I can't say that the "rewrite it entirely" 
> > > approach of the previous-gen cards has worked very well either, since that 
> > > seems to have just perpetuated the problems. It would be great to try to 
> > > educate them, but I'm not finding even an email address in the sources.
> > 
> > I've send a mail to Ralink with a request if they could step away from the
> > "port the windows driver to linux" idea and get the Linux driver "kernel-ready"
> > early on.
> > That won't solve the problem now, but hopefully it does mean the drivers for
> > the next generation can go into the kernel sooner.
> 
> The Ralink guys are being educated and AFAICT they are interested in
> better participation.  Time will tell, of course.
> 
> In the meantime as Ivo indicated he is "on the case" -- I think we
> will see something before too long.

For the interested, the rt2800pci and rt2800usb code which I am working on can
be found in the experimental branch of my repository:
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=shortlog;h=experimental
Because the code is incomplete it cannot be tested, but it gives at least an idea
on what is already done. ;)

Ivo
