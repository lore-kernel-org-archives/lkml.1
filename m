Return-Path: <linux-kernel-owner+w=401wt.eu-S1422851AbXCBEXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422851AbXCBEXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422853AbXCBEXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:23:00 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:36040 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422851AbXCBEW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:22:59 -0500
Message-ID: <45E7A69F.40407@blueyonder.co.uk>
Date: Fri, 02 Mar 2007 04:22:55 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E5DE32.2070902@argo.co.il> <45E6DA9A.2030301@blueyonder.co.uk> <45E6ED26.10308@argo.co.il>
In-Reply-To: <45E6ED26.10308@argo.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Sid Boyce wrote:
>>> > That's very much appreciated. The point is that all vanilla 
>>> kernels up
>>> > to 2.6.20+ have not had the problems now seen on 2.6.20-rc1 and
>>> > 2.6.20-rc2 and like other problems reported, sic framebuffer, etc.,
>>> > there is a distinct likelihood that it's related to those kernels and
>>> > worth reporting here where it will also be seen by the openSUSE 
>>> kernel
>>> > developers.
>>>
>>> Try running an strace on kwin and reporting the result.
>>>
>>>
>> Modified /opt/kde3/bin/startkde as below, but got no output, not even 
>> an empty file.
>> strace -s 256 -f kwin --lock -o /home/lancelot/KWIN.out &
>
> Perhaps that line is never executed.
>
> Try running kwin from your konsole after it dies, with the strace of 
> course. Oh, and put the '-o ...' before the kwin command, not after.
>
>

Oops!, above text should read the same as the subject line,  problems 
seen on 2.6.21-rc1 and 2.6.21-rc2.
The strace is huge 2737627 2007-03-02 03:28 KWIN.out.  Further digging 
shows kwin, kicker and klauncher and perhaps other kdeinit stuff also 
die - no desktop icons after those 3 are started from the commandline. 
Moving kdesktop_lock out of /opt/kde3/bin, everything comes back after 
the video is blanked -- no password required.
I shall run like that (2.6.21-rc2-git1 currently) and wait for openSUSE 
to upgrade to 2.6.21. I can send the straces of kicker and kwin on if 
you think it's still worth it.
Thanks and Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


