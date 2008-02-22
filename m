Return-Path: <linux-kernel-owner+w=401wt.eu-S1765217AbYBVW7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765217AbYBVW7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYBVW7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:59:38 -0500
Received: from khc.piap.pl ([195.187.100.11]:38690 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbYBVW7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:59:37 -0500
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Newall <davidn@davidnewall.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Glenn Streiff <gstreiff@neteffect.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Faisal Latif <flatif@neteffect.com>
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	<m3tzk1q3rt.fsf@maximus.localdomain>
	<47BE2985.6020305@davidnewall.com>
	<e2e108260802220429l5857c3edj351246ee31dd2a3e@mail.gmail.com>
	<47BEDB3F.4090100@davidnewall.com> <1203693437.6242.40.camel@lappy>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 22 Feb 2008 23:59:35 +0100
In-Reply-To: <1203693437.6242.40.camel@lappy> (Peter Zijlstra's message of "Fri\, 22 Feb 2008 16\:17\:17 +0100")
Message-ID: <m3ve4g38dk.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> So, yes, I have the screen estate for very long lines, but I find that
> long lines require more effort to read (that very much includes leading
> whitespace). Also, since long lines are rare (and they should be, if you
> nest too deep you have other issues) accommodating them would waste a
> lot of screen estate otherwise useful for another column of text.

Either they are rare and you can wrap them and still use 80 columns,
or it turns out they are not so rare and you may want to use wider
windows (not necessarily 132 but perhaps 100).

I think the question isn't if they are rare or not, or if people have
3 * 1920 pixels/line or just 1280.

The question is: is the code more readable with hard limit equal to 80
characters, or maybe is it better to limit code block complexity
instead, and let the maximum number of those small pictures in a line
alone? (Limiting at 132 would have technical sense IMHO).

Better code readability = less bugs without any additional
effort.

> Even with e-mail, I can easily show over 200 characters wide with a
> large font (say 11pt) but find it harder to read emails that don't
> nicely wrap at 78.

Sure - because email is not C code.

Actually you don't "read" C code, word by word, as you read books - do
you?
-- 
Krzysztof Halasa
