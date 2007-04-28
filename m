Return-Path: <linux-kernel-owner+w=401wt.eu-S1163418AbXD1SLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163418AbXD1SLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163420AbXD1SLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:11:03 -0400
Received: from www17.your-server.de ([213.133.104.17]:1376 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163411AbXD1SKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:10:45 -0400
Message-ID: <46338DF8.8010901@m3y3r.de>
Date: Sat, 28 Apr 2007 20:10:00 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Meyer <thomas.mey@web.de>
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
References: <463375E5.5040108@googlemail.com> <1177779971.7646.271.camel@localhost.localdomain>
In-Reply-To: <1177779971.7646.271.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
> On Sat, 2007-04-28 at 18:27 +0200, Michal Piotrowski wrote:
>   
>> Subject    : Bad interaction between dynticks and amarok?
>> References : http://lkml.org/lkml/2007/4/26/307
>> Submitter  : Thomas Meyer <thomas.mey@web.de>
>> Status     : Unknow
>>     
>
> Michal,
>
> I don't think this is a regression. What Thomas wanted to point out is,
> that the amarok / sound device is making the positive effect of dynticks
> moot, as it starts to trigger useless interrupts.
>
> Thomas, is my interpretation correct ? Did you check, which interrupt
> was increasing - i.e. was it the soundcard one ?
>   
No, it wasn't the soundcard one. but i had this effect with amarok and
audacious... so, i guessed... which was wrong.

It's the timer interrupt (+50-70 timer interrupts). But i'm not sure
what both applications are doing, while they are "idle"...

with kind regards
thomas

