Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZIZCrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZIZCrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 22:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZIZCra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 22:47:30 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:38403 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZIZCra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 22:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ggym7asMPDCoUSP+2dbIBXkY0mfnfv0qodL1KRvS2JlcDiK9CeE4bSkUF5tu0EqlaA
         psFC5ZeO+v4SMqEWM4um4Gm3gNJLRSqrTSBDCksPk5xp+qBF1WNVjJkDodOkoc5vD5po
         k38td8vYO+2PvVzK32xNjGlaSrXY/vaAy7CCY=
Message-ID: <4ABD80C1.8060907@gmail.com>
Date: Fri, 25 Sep 2009 20:47:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Loren Rogers <loren.rogers@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel getting hosed?
References: <e25071430909251802o5d269deas9282e07290234a01@mail.gmail.com>
In-Reply-To: <e25071430909251802o5d269deas9282e07290234a01@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2009 07:02 PM, Loren Rogers wrote:
> Hello,
> I am developing a multi-threaded media-based application written for
> an iMX27-based processor running kernel 2.6.24.  But I'm seeing a
> weird "phenomenon" where certain processes/threads are not being
> serviced and my clock (according to gettimeofday()) get's set back as
> well.  There are many symptoms to this behavior.  Here are some
> symptoms:
>
> 1. It's usually the same application-based threads that are either
> being serviced or not serviced
> 2. The problem usually lasts for about 5 and a half minutes and then
> appears to correct itself
> 3. I'll see the cpu load for my application-process quickly jump up to
> 99% right before the phenomenon (according to top)
> 4. My IP-telnet and serial terminal sessions are both unusable.
> 5. I have a logging utility with a timestamp feature (gettimeofday())
> where, once this problem corrects itself, the clock has been set to
> the exact time the problem started (i.e. let's say the problem starts
> at 12:00:00, and I'll be logging msgs like 12:01:00, 12:04:22, etc...
> Then after the problem "stops" the timestamp on my logger is once
> again 12:00:00).  And when I do a command "date" the clock will say
> 12:00:00!
> 6. I think all of my IP-based network threads are being serviced.
> 7. A colleague wrote a utility on one of the "alive" threads to start
> collecting proc data once we know we are in this state; and he told me
> that the proc counters have pretty much halted.
>
>
> My colleagues and I have been chasing this for three weeks now.  I
> have no clue on how to determine the culprit(s).  At first I thought
> it was some bad code in the user-based application, but can someone
> tell me with 100% certainty that this is either a user-space problem
> or a kernel problem?  If it is a kernel problem, how can a user-space
> application hose a kernel to this extent?
>
> If anybody can help me with some tool or tools to help diagnose the
> cause of the problem or even where to start looking I would REALLY
> appreciate it.  Thank you

If the system clock is jumping backwards then unless some process is 
mucking with the clock, sounds like there's some kind of kernel 
timekeeping problem on that platform..
