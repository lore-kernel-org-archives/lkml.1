Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYBFNzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYBFNzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYBFNyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:54:51 -0500
Received: from twin.jikos.cz ([213.151.79.26]:53792 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYBFNyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:54:51 -0500
Date: Wed, 6 Feb 2008 14:54:21 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1202305740.9058.22.camel@popeye>
Message-ID: <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
 <1202305740.9058.22.camel@popeye>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Chris Holvenstot wrote:

> On this system I am using a PS2 Keyboard - and let me stress that it is 
> only occasionaly that it happens - I have had 2.6.24-git15 up for about 
> 2 hours now and have only seen it about a dozen times. I also note one 
> other thing - although my system is lightly loaded - at this time of day 
> I am pretty much just using email on an AMD 64 X2 4600+ with 2 gigs of 
> of memory - I have noticed several times that I will be typing away and 
> nothing is appearing on the screen - and a few seconds later - boom - 
> there it all is.

It could be some timing problem. Does this happen also in console, or 
only when running X?

Could you please try to

- boot with 'nohpet' kernel parameter
- taskset -p 0x00000002 <pid_of_Xserver> if this is a multi-CPU/core 
  machine and you are experiencing the problems only in X

Thanks,

-- 
Jiri Kosina
