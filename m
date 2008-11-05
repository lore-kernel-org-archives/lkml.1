Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYKESOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYKESOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYKESOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:14:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:26421 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYKESOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:14:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jn3WzouPZZJnbKqGO56Q5d5cub4yAgZOzVel7j+Cib9q/AZ1gTzUN+6+Djvujj+qcP
         2JXPm0970LpcUJVjhrKTD+6QzUDCh52RogDO+VHqVzESWBLipzGkCcuIa8I6/SeoHvPM
         OSd27cHh2nA7Yn5bpl7W+3z9SXYBMYrmFHn3w=
Date: Wed, 5 Nov 2008 21:14:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081105181405.GE7286@localhost>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104212933.GA11050@elte.hu> <4910C014.9070805@zytor.com> <20081104215245.GC17775@elte.hu> <20081105175318.GD7286@localhost> <4911E042.8040404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4911E042.8040404@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Nov 05, 2008 at 10:04:50AM -0800]
| Cyrill Gorcunov wrote:
| > 
| > Ingo, what the conclusion is? As I understand from the thread --
| > 
| > 1) Implement Peter's proposed cleanup/compress.
| > 2) Test Alexander's patche.
| > 
| > Did I miss something?
| > 
| 
| Nope, that's pretty much it.
| 
| However, there are good reason to believe that using this kind of
| segment selector tricks is probably a bad idea in the long term,
| especially since CPU vendors have strong incentives to reduce the size
| of the segment descriptor cache now when none of the mainstream OSes
| rely on more than a small handful of segments.
| 
| I was planning to look at doing the obvious stub shrink today.
| 
| 	-hpa
| 

I see. Thanks! Btw Peter, I remember I read long time ago about
segment caches (well... in time of DOS programming actually). But
there was only 'common' words like this cache exist. But maybe
it's possible to know what exactly size of such a cache is?
You mentoined number 32. (heh... I hadn't remember it until
you mentoined about such a cache :-)

		- Cyrill -
