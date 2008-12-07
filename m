Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYLGXtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYLGXtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 18:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYLGXs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 18:48:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:21880 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750931AbYLGXs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 18:48:59 -0500
Message-ID: <493C60E3.7070303@ru.mvista.com>
Date: Mon, 08 Dec 2008 02:48:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz: add missing handling of clocksource watchdog
References: <200812080015.22793.bzolnier@gmail.com> <200812080036.59506.Rafal.Wysocki@fuw.edu.pl>
In-Reply-To: <200812080036.59506.Rafal.Wysocki@fuw.edu.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

R. J. Wysocki wrote:
> On Monday, 8 of December 2008, Bartlomiej Zolnierkiewicz wrote:
>   
>> Fixes "Clocksource tsc unstable (delta = -974982308 ns)" problem.
>>     
>
> Where can I find the description of the problem?
>   

   Kernel.org bug #10216 (it's not about this issue though).

> Rafael
>
>   
>> [ IDE was unlucky to be initialized at the same time that
>>   clocksource watchdog triggers and was blamed for the issue. ]
>>     

   I think it might well have been blamed correctly -- the clocksource 
watchdog timer gets run every half second.

MBR, Sergei


