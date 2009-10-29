Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZJ2RwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZJ2RwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 13:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZJ2RwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 13:52:09 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:45104 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZJ2RwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 13:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YDszHQyuZYGiS0yWzFnX2UtUiW6VBcZA3URoWYE1g2OQ9JTBFkQMSmPk6JAQl7VpTO
         a9eAKcs5Wvcam5vTirs/ymtxeWiKPgH0ZX7h8sMxpSeZMF8GMWzOzcXElmh7ZFrSSB8h
         he7irWJc73FDQ28VuZJtcecQ5CZYq6Etp+cHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Thu, 29 Oct 2009 18:49:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: penberg@cs.helsinki.fi, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
References: <200910291435.54203.bzolnier@gmail.com> <200910291514.40318.bzolnier@gmail.com> <20091029.072101.109209962.davem@davemloft.net>
In-Reply-To: <20091029.072101.109209962.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910291849.23526.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 October 2009 15:21:01 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Thu, 29 Oct 2009 15:14:40 +0100
> 
> > Dave, if you have problems with executing the command locally I'll be
> > happy to supply you with the patch.
> 
> This is not the issue.
> 
> The issue is that John disagrees with you can you can't handle
> that.
> 
> So instead of continuing to discuss things with him and the
> other wireless folks, you want me to just overreach everybody
> and revert someone else's work.

Lets look at the technical merits of this work.

It is 5 KLOC of dead code and it should be 1-2 KLOC of working code
(we may turn the blink eye on "working" part but FFS at least fix other
parts)..

Hey, Linus.  We have a new driver for ya.  It doesn't work, has design
problems and is not even half-finished but most wireless folks are fine
with it!

I wonder when things went so wrong here..

> I'm not going to do that sorry, learn how to work with the
> wireless people instead.

This is a waste of time since technical merit doesn't find much love there.

Sorry Dave but you're making me go over your head now and go into unpleasant
mode again..

Looking on how you just reverted cmd64x change which you were so proud while
taking IDE over shows where the real problem is -- in subsystems supervised
by you loyalty and rank is everything while you are busy playing the pointy
haired boss everywhere from arm to ide.

--
Bartlomiej Zolnierkiewicz
