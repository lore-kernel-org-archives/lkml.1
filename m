Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYCZTJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYCZTJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYCZTIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:08:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52315 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYCZTIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:08:54 -0400
Date: Wed, 26 Mar 2008 20:09:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip OTP memory
Message-ID: <20080326190917.GB24954@uranus.ravnborg.org>
References: <1206580131-22527-1-git-send-email-cooloney@kernel.org> <47EA268F.8070006@gmail.com> <8bd0f97a0803260731x4378c71q1e2e5598c1728e1d@mail.gmail.com> <47EA971B.1020502@gmail.com> <8bd0f97a0803261140w7498b0cfwff38302779f589dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0803261140w7498b0cfwff38302779f589dc@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >  > also, it isnt "broken" in the sense that it "doesnt work" ;)
> >
> >  Gcc simply doesn't allow that, you likely got 2 sections with init.data, with
> >  and without readonly bit set, which is wrong, and it seems, that on some systems
> >  (debian) you won't even compile it.
> 
> gcc-4.1.2/binutils-2.17 doesnt have a problem compiling/linking the
> code in question.  and i imagine i would have noticed a build/link
> failure long before testing it on actual hardware.
target arch dependent. Try with 64 bit powerpc.

	Sam
