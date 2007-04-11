Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbXDKKqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbXDKKqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXDKKqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:46:37 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:55268 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbXDKKqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:46:36 -0400
Message-ID: <461CBC3A.5090607@gmail.com>
Date: Wed, 11 Apr 2007 12:45:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
References: <460B6E4B.3060004@gmail.com> <200704092220.10039.rjw@sisk.pl> <461C8FF4.80202@gmail.com> <200704111155.52455.rjw@sisk.pl>
In-Reply-To: <200704111155.52455.rjw@sisk.pl>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 11 Apr 2007 12:46:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Wednesday, 11 April 2007 09:36, Jiri Slaby wrote:
>> Rafael J. Wysocki napsal(a):
>>> On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
>>>> I have bad news for you :(. I thought I had unpatched kernel, but it happens
>>>> in -rc6 too.
>>> I guess you mean you're still seeing the 'not enough memory to suspend'
>>> problem?
>> Yes:
>> Disabling non-boot CPUs ...
>> kvm: disabling virtualization on CPU1
>> Breaking affinity for irq 9
>> CPU 1 is now offline
>> SMP alternatives: switching to UP code
>> CPU1 is down
>> swsusp: critical section:
>> swsusp: Need to copy 158309 pages
>> swsusp: Not enough free memory
>> Error -12 suspending
>> Enabling non-boot CPUs ...
>> SMP alternatives: switching to SMP code
>> Booting processor 1/2 APIC 0x1
>> Initializing CPU#1
> 
> How reproducible is it?  I'm going to try to reproduce it on one of my boxes.

My tip is one of three cases: after some work on fresh boot -- some
consumers such as thunderbird, firefox, 10 or so terminals with
gnome-session. Single xterm + gnome-session semms not to be a problem.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
