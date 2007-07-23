Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXGWMo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXGWMo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbXGWMoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:44:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:8513 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbXGWMoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J9QJ63QFsfeyozjZBmssbBzus2HY1rP4xnbOAZd/QvhQAJ8gSaEY1HYuziyvIegOYeJnGjzSpv3WqTbqDoBv0yft5DKAZEyljWYQ7VL20ANj5kYGGMiK3PRVs1gLEi3nwGWg/0hzdrkjjVpqDA9dJUAkj10H/X5+aQL7kCdJ6rw=
Subject: Re: [PATCH] Fix fbcon - 'map_override' defined but not used warning
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46A49A0A.4070506@googlemail.com>
References: <46A38486.70903@googlemail.com> <1185171524.5046.2.camel@daplas>
	 <46A49A0A.4070506@googlemail.com>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 20:44:08 +0800
Message-Id: <1185194648.5046.13.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 14:07 +0200, Gabriel C wrote:
> Antonino A. Daplas wrote:
> > On Sun, 2007-07-22 at 18:23 +0200, Gabriel C wrote:
> >> Hi,
> >>
> >> I got this warning on current git:
> >>
> >> ...
> >>
> >> drivers/video/console/fbcon.c:130: warning: 'map_override' defined but not used
> >>
> >> ...
> >>
> >> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> >>
> >> ---
> >>
> >> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> >> index decfdc8..60a14de 100644
> >> --- a/drivers/video/console/fbcon.c
> >> +++ b/drivers/video/console/fbcon.c
> >> @@ -127,7 +127,9 @@ static int last_fb_vc = MAX_NR_CONSOLES - 1;
> >>  static int fbcon_is_default = 1; 
> >>  static int fbcon_has_exited;
> >>  static int primary_device = -1;
> >> +#ifndef MODULE
> > 
> > Disrecard my other comment. This should be
> > 
> > #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
> 
> You really sure ? 

Yes, I realize that. I already have a patch in my tree that will fix
this properly.

Tony


