Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYLGWM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYLGWM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYLGWMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:12:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:55533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYLGWMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:12:17 -0500
Date: Sun, 7 Dec 2008 14:13:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Message-ID: <20081207141337.588aede5@infradead.org>
In-Reply-To: <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	<493AE770.5030507@shaw.ca>
	<12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>
	<493AF2EA.4030601@shaw.ca>
	<12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
	<493B4242.1040202@shaw.ca>
	<12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2008 22:55:10 +0100
"Giangiacomo Mariotti" <gg.mariotti@gmail.com> wrote:

> On Sun, Dec 7, 2008 at 4:25 AM, Robert Hancock <hancockr@shaw.ca>
> wrote:
> >
> > If it only happened once then who knows, could be a cosmic ray or
> > something.. but if it happens again it sounds like you likely have
> > a bad CPU.
> >
> This same MCE happens every time I boot the 2.6.27.8 kernel, but it
> never happens with kernel 2.6.26.8. It appears every time at log time
> [  301.7320xx](where the x represent the scale of the approximation).
> In the previous log it appeared at [  301.732037], now it appeared at
> [  301.732042]. It happens just once at that moment and then never
> more until I reboot. No MCE gets logged with kernel 2.6.26.8 nor with
> Windows Vista 32bit, not even under very heavy load on memory and
> cpu(like 3d games or 3d mark vintage). Is this really an hardware
> problem? Why does it get logged only on kernel 2.6.27.8 at that exact
> moment? Now I'm gonna compile kernel 2.6.28-rc7 and see if there it
> happens too. Any suggestion? It would be appreciated, because,
> depending on the final result, I may be forced to change the
> hardware(It's still guaranteed, but it'd mean some months without a
> pc).

which video driver are you using?
While your HW might be defective (MCE's tend to indicate that), if it's
software dependent it might also indicate that something, usually a
video driver, gets the system in a really bad state.
Also, make sure that you have MCE enabled in both kernels (I'm sure you
do, but it's one of those things worth double checking)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
