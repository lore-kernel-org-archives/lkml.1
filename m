Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbYBZOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbYBZOqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYBZOqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:46:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYBZOqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:46:05 -0500
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	<87k5kt6vd3.fsf@pike.pond.sub.org>
	<45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Tue, 26 Feb 2008 15:45:43 +0100
In-Reply-To: <45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com> (Jaya Kumar's message of "Tue\, 26 Feb 2008 09\:11\:45 -0500")
Message-ID: <871w6z6ajs.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaya Kumar" <jayakumar.lkml@gmail.com> writes:

> On Mon, Feb 25, 2008 at 8:03 AM, Markus Armbruster <armbru@redhat.com> wrote:
>>
>>     Subject: [PATCH 1/1 2.6.24] fbdev: defio and Metronomefb
>>     From: Jaya Kumar <jayakumar.lkml@gmail.com>
>>     Date: 2008-02-18 13:41:26
>
> Hi Markus,
>
> Andrew pointed out that there may be race conditions associated with
> this patch. [ http://marc.info/?l=linux-fbdev-devel&m=120376473020396&w=2
> ] So I would not encourage anyone to merge it. I'll try to figure
> things out this weekend.
>
> Thanks,
> jaya

Thanks for the timely info.  I'm not in an undue hurry to get this
merged.  As long as we're moving forward, I'm happy.

What about pushing the fb_defio fixes independently of any new
fb_defio users?  If fb_defio was worth merging into Linus's tree, it
should be worth fixing there, whether new users are in shape already
or not.

If we must have a new user, well, I could easily whip up something
like FB_VIRTUAL on top of fb_defio.
