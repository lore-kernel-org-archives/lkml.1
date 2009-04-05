Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZDEERs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZDEERs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZDEERi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:17:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:39454 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZDEERh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=IN+xIFjDMKN44LY5250H2rwGKzzxms4WfbXNVvKrERvq0QFFTu76ChuMtCi7AB+62j
         WME1KaIqnH+0Qz1p0WzRfSnyiT1PJNuDQ5n7hjtuurONmML7s1QmwrYrx1s6wpq8tIxg
         LICqyXAc4s2JGCbpX5Ys58hAzc2ztM/9HMN9Y=
MIME-Version: 1.0
In-Reply-To: <20090405011355.GE7553@mit.edu>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	 <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com>
	 <20090405011355.GE7553@mit.edu>
Date: Sat, 4 Apr 2009 22:17:35 -0600
Message-ID: <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
Subject: Re: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 4, 2009 at 7:13 PM, Theodore Tso <tytso@mit.edu> wrote:
> Trenton.  Couple of things to try.  First of all, it looks like your
> application is multi-threaded.  That's why it can drive up the load so
> high, even though "ps" and "top" is only showing one process.  Try
> using the -f flag to strace so you can follow all of the processes and
> threads fork()'ed or cloned()'ed from the initial process.
>
> In addition, here's a rather brute-force script that I've used when
> trying to collect data when debugging performance or long-term
> stability problems at customer sites.  Very often it was used on
> production machines where they don't allow random people to poke
> around on it, so this was designed to be given to a sysadmin, who
> would approve running it on their system, and some hours later, we
> would get the tarball, and then try to figure out what the heck was
> going on.
>
> It doesn't have to run out of cron, BTW; it also can be run from a
> command-line, and some of the polling intervals adjusted smaller if
> you need finer-grained resolution, or it can run as a stand-alone
> daemon as well.
>
>                                                - Ted

Hi Ted,

I would imagine it is multi threaded, though I am not positive.  I am
asking on IRC right now.

I will look into trying out your tests, and the -f flag.  I will
report back once I have more data.  The good thing is that once the
problem starts happening, it continues to happen.  I think it happens
until reboot, but I'm not positive.  I'm about to try again, so we'll
see, as I have not rebooted since last time.

Thanks.
