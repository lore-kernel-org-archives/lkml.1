Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYGRMYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYGRMYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbYGRMYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:24:25 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:9826 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbYGRMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:24:22 -0400
Date: Fri, 18 Jul 2008 14:28:49 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rene Herman <rene.herman@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [boot crash, bisected] in 9f240a55
 "ALSA: opti93x: use cs4231 lib"
Message-Id: <20080718142849.f11ce4c8.krzysztof.h1@poczta.fm>
In-Reply-To: <48806017.1040307@keyaccess.nl>
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>
	<20080717170657.GA14593@elte.hu>
	<s5h3am8jqvy.wl%tiwai@suse.de>
	<487F9B9B.2010905@keyaccess.nl>
	<487F9FA1.7020101@keyaccess.nl>
	<48806017.1040307@keyaccess.nl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: b8e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 11:19:19 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 17-07-08 21:38, Rene Herman wrote:
> 
> > On 17-07-08 21:20, Rene Herman wrote:
> > 
> >> On 17-07-08 20:40, Takashi Iwai wrote:
> >>
> >>> Could you try the patch below?
> >>
>
> This bug was uncovered by !CONFIG_PNP and we had trouble in this driver 
> due to that before so was rewriting the init to be a generic multi-card 
> ALSA init but, actually, not much point.
>

The bug was introduced by the patch as it used (tried to free) the codec pointer
before it was assigned any value. It happened only if the card was missing and
I didn't test the driver on such a configuration. My mistake. The CONFIG_PNP
setting makes no difference.
 
> 
> In fact, in the meantime I'll look at splitting 92x and 93x again. It's 
> much better now that Krzysztof made it use the generic library code but 
> I still hate this driver. It's also poking at ports without being told 
> something is there by either system or user.
> 

Please hold your axe until Monday. The last patch (not posted yet) from the 
unification of the WSS library series removes some ifdefs in this driver.
This may (or may not) change your view on splitting the driver.

Regards,
Krzysztof

----------------------------------------------------------------------
Zobacz cala prawde o Lukaszu Podolskim!
kliknij >>> http://link.interia.pl/f1e57

