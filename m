Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZLVVKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZLVVKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZLVVKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:10:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZLVVKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:10:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=I5ecopzs8iAfg0esxWLlo6/LiCRn5ZPdJDONVYD98+EdKyQ+G5UxUdo+dJi0u0lZG
	YMutRSUXW11nPolzTmaqQ==
MIME-Version: 1.0
In-Reply-To: <20091218170407.GA1396@ucw.cz>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	 <20091218170407.GA1396@ucw.cz>
Date: Tue, 22 Dec 2009 13:10:36 -0800
Message-ID: <4352991a0912221310k40f42498nba2081011398c7e@mail.gmail.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the 
	Linux Kernel
From: Salman Qazi <sqazi@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 9:04 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi
>
>
>> Why not use voltage and frequency scaling?
>>
>> Forced Idle Injection is more effective[1] and more widely available.
>> Even with voltage and frequency scaling, interpolation is needed
>> between the available settings.  So, if we did use voltage and
>
> It is only more efficient on new hardware.
>
> You should also explain 'why not throttling' because that is actually
> designed for power capping.

Do you mean t-states?

>
>> Application to Laptops and Cellphones:
>>
>> Imagine being in a tent in Death Valley with a laptop.  You are bored,
>> and you want to watch a movie.  However, you also want to do your best
>> to make the battery last and watch as much of the movie as possible.
>> Forced idle power capping is a solution.  If your machine has a knob
>> that allows you to control the available power, you can turn that knob
>> until your video starts getting choppy.  And then, turn the knob back
>
> That's bad example. Video player should already sleep between frames.

Yes, the video player should sleep.  However, there will be other
things running.  And certainly, it is possible to cap the power and
discriminate so that those things are prevented from running while the
video player is allowed to run with minimal latency impact.

>
> Better example would be 'make video so choppy that expected battery
> time rises over length ov movie.
>
> (And yes, this would have been useful for me on notebook with failed
> fan and ineffective throttling).
>
>
>                                                                Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
