Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYLBOkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYLBOkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYLBOkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:40:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39339 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754270AbYLBOkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:40:22 -0500
Date: Sun, 23 Nov 2008 19:01:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: jonsmirl@gmail.com, jrm8005@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: In-kernel IR remote control support
Message-ID: <20081123180146.GA7731@ucw.cz>
References: <20081115115859.GA1572@ucw.cz> <AqQThtpZjFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AqQThtpZjFB@christoph>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Who is telling you that LIRC cannot work like simply plugging in the  
> receiver and start using the remote?

Well, I don't have to install special userland to make USB keyboard to
work,  and I don't see why remote controls should be different.

> You can have LIRC setup to decode all common remote control protocols.  
> It's just a matter of proper packaging and pre-configuration.

...which distributions don't generally do because they avoid
out-of-tree patches...?

> > Can we merge the common ones into the kernel, while still keeping the
> > obscure ones in userspace using uinput or something?
> 
> Why do you want to complicate things even more. When you have an obscure  
> protocol, you have to use LIRC style kernel drivers anyway. Why not use  
> them for all protocols if you need them anyway?

It is more complex in the obscure case, agreed; but the common case
gets simpler and I believe tradeoff is worth it.

> Everyone seems to be so focussed on the input layer, that he does not even  
> consider that it might not be the right approach for all cases.

Remote controls do look like keyboards; that's why people want to use
input layer.

Unlike normal keyboards, 'tcpdump' or 'irdump' makes a lot of sense
for remote controls, but so what?

> > support for the common remotes. That seems like a net plus to me, and
> > you can still keep the obscure ones in userland.
> 
> Jon's code and the LIRC approach exclude each other. It does not make  
> sense to have both in the kernel. There have been attempts to clean up  
> LIRC code to be included in the kernel. The current discussion lessens my  
> hope that this will happen anytime soon.

I don't see why we could not use Jon's code for common remotes decoded
mostly by hw, and your code for the obscure cases.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
