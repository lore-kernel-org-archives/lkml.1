Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYKES0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYKES0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYKES0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:26:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:40983 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYKES0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:26:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B5Bryh921XPl6GB4Z1fiy1gzVxvO0EqZFYRq2AhsQe0jMXpqWmjQIzLHNAxlN7DzA1
         tgabsnobg/0yBkoZ6X1k1ELoZQxABLgoUGh2iTWb3dCzZK7Fr9cFnXaL4QEYlw6DElRY
         EAq5eJNWXhvainP/9gMq/yVXnk++rFfLmp+io=
Date: Wed, 5 Nov 2008 21:26:15 +0300
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
Message-ID: <20081105182615.GG7286@localhost>
References: <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104212933.GA11050@elte.hu> <4910C014.9070805@zytor.com> <20081104215245.GC17775@elte.hu> <20081105175318.GD7286@localhost> <4911E042.8040404@zytor.com> <20081105181405.GE7286@localhost> <4911E3E7.6090109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4911E3E7.6090109@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Nov 05, 2008 at 10:20:23AM -0800]
| Cyrill Gorcunov wrote:
| > 
| > I see. Thanks! Btw Peter, I remember I read long time ago about
| > segment caches (well... in time of DOS programming actually). But
| > there was only 'common' words like this cache exist. But maybe
| > it's possible to know what exactly size of such a cache is?
| > You mentoined number 32. (heh... I hadn't remember it until
| > you mentoined about such a cache :-)
| > 
| 
| As with any other caching structure, you can discover its size,
| associativity, and replacement policy by artificially trying to provoke
| patterns that produce pathological timings.
| 
| At Transmeta, at one time we used a 32-entry direct-mapped cache, which
| ended up with a ~96% hit rate on common Win95 benchmarks.
| 
| I should, however, make it clear that there are other alternatives for
| speeding up segment descriptor loading, and not all of them rely on a cache.
| 
| 	-hpa
| 

Thanks a lot for explanation!

		- Cyrill -
