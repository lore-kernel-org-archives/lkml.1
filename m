Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbXDBJay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbXDBJay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXDBJay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:30:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:58055 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277AbXDBJax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lYYvE+Nc1w/Rx2pkLU5qY38UXQ0Udc6FMjs2NSAYyqyu9gJCY63Fc5u94ZmLXBEibHEiyVjYgvLFIGqD2F37J3cG2pjkXfn60POn+sxwd5sEz4r0wl2/CZl+2ZRq2RK/niKlU2k37lxkQIkUCXM0KVDXc+iAB/xnhFzSjURJ8p4=
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Daniel Jacobowitz <dan@debian.org>
In-Reply-To: <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr>
	 <1175496595.4614.11.camel@daplas>
	 <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 17:30:45 +0800
Message-Id: <1175506245.4431.0.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 09:31 +0200, Jan Engelhardt wrote:
> On Apr 2 2007 14:49, Antonino A. Daplas wrote:
> >On Sun, 2007-04-01 at 20:13 +0200, Jan Engelhardt wrote:
> >
> >> Allow for the palette to be exposed and changed via sysfs. A call to
> >> /usr/bin/reset will slurp the new definitions in for the current
> >> console.
> >
> >I like this. The escape sequences to change the palette does not stay
> >permanently.
> 
> As much as you like it, there is a slight problem with it. Linux will
> currently throw virtual consoles out of UTF8 mode when reset is called.
> 
> Also see:
> 	http://lkml.org/lkml/2005/5/17/289
> 	http://lkml.org/lkml/2005/5/17/297
> 
> These posts argue about terminfo being the culprit. But how can terminfo 
> be at fault, when `echo -en "\ec"` triggers it too?
> 
> Since I am in a patch mood, here's my stance/patch, which is compile and 
> run tested and behaves as expected (both with `echo` and `reset`).

Tested and works here too.

Tony


