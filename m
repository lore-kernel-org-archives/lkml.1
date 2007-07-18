Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbXGRFB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbXGRFB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXGRFBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:01:18 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:6824 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXGRFBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YQWRusRJnMlrmpen0IEY5NlveKMKJpOVMrwafYBZpwJDbmHA6hrAtQjXc3YBzpHTcLJon2ij+AH54yx06bnrmQ+QnCWELYmgsTxy+TcrpSlZlqnEU2ONkUhI2HIRQbnkF1du+12hx74yrbL79aUl8pR5sTU/a39ciP9crR20/7Q=
Message-ID: <d9a6586e0707172201m557b91fy5c356d8c98215ffa@mail.gmail.com>
Date: Tue, 17 Jul 2007 22:01:16 -0700
From: "Shawn Rutledge" <shawn.t.rutledge@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: attempting to open a VT from elsewhere and take raw keyboard input
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707172135110.27468@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9a6586e0707170151r799ccff1gcd0a84e7f3524cd5@mail.gmail.com>
	 <Pine.LNX.4.64.0707172135110.27468@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I know that X does it; I'm trying to write a new windowing system
which also does that, and the question is how they did it.  I would
have expected if I just open /dev/tty1, set raw mode, and set some
termios flags I'd get every key press and release; and it would be my
choice whether to use blocking or non-blocking I/O.

On 7/17/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jul 17 2007 01:51, Shawn Rutledge wrote:
> >
> > I'm messing around with framebuffer graphics stuff and trying to write
> > a keyboard driver similar to the one in X, which will allow you to
> > start up the graphics system from any tty (not just a virtual
> > console),
>
> right, I can start X these days over SSH (either init5 or startx)
>
> > find an available VT, switch to that VT,
>
> X does that automatically ('regular' X, not considering Xdmcp or such)
>
> > and then take input from the physically attached keyboard rather
> > than necessarily
>
> X does that too.
