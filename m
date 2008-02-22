Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbYBVOIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbYBVOIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYBVOHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:07:55 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:49798 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbYBVOHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:07:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Fri, 22 Feb 2008 15:07:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <20080220193709.GD21139@uranus.ravnborg.org> <97a0a9ac0802212024w62dbfb03ye62c51744e853b36@mail.gmail.com>
In-Reply-To: <97a0a9ac0802212024w62dbfb03ye62c51744e853b36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221507.15871.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 05:24:32 Gordon Farquharson wrote:
> Hi Sam
> 
> On Wed, Feb 20, 2008 at 12:37 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> >  Option 1) is the worst of the three as that can cost
> >  of many hours bug-hunting.
> >  Option 3) may seem optimal but I do not like to add more
> >  complexity to this part of the build. And really I do not
> >  know a reliable way to detech when we do cross builds anyway.
> >
> >  Leaving us with option 2) that is simple, strighforward and harmless.
> 
> Are you willing to sign off on and commit the patch?

Only with a big fat comment added that the alignment is only needed
because of a broken sanity check in file2alias.c.

-- 
Greetings Michael.
