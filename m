Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYBHXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYBHXtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYBHXtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:49:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:23983 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYBHXtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fhsp4WuAsr8nwWgmF9ka3Sqc65+PuvImJ7PtFvyiAEpaCd/0rIyCyA8RhBcTxNX3pCXvoOGD2isowOyTRTrxP7Q9WpHTVC0pEZG/wgWyQ5RDBM1ulO0W5HzvpQ7+yAecmCf34CMVJWtAGV1RbE/5IPgXNnzlCG8nG0w0jLe8K/o=
Message-ID: <9a8748490802081549q4c100e4cr8682563fda098340@mail.gmail.com>
Date: Sat, 9 Feb 2008 00:49:06 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [patch] [git pull] Input updates for 2.6.25-rc0
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Dmitry Torokhov" <dtor@insightbb.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080208153741.54409a7a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802060108.31644.dtor@insightbb.com>
	 <20080208232536.GA15727@elte.hu> <20080208152812.2bb14374@extreme>
	 <20080208153741.54409a7a.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2008, Randy Dunlap <randy.dunlap@oracle.com> wrote:
...
> > On Sat, 9 Feb 2008 00:25:36 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> >
...
> > I think someone already sent a patch to select the LEDS
>
> I did... and more.  Who will merge it?  (below)
>
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add I2C to config since the driver makes several i2c*() calls.
>
> Add to help text that the Intel I2C ICH (i801) driver is also needed
> for this kernel.
>
> Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
> ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
> ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko] undefined!
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

I guess I could stick it in the Trivial tree and push it during the
2.6.26 merge window if it doesn't get merged elsewhere before that.
It looks reasonably trivial.

At least that way it doesn't get lost :)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
