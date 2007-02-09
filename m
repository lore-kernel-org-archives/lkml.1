Return-Path: <linux-kernel-owner+w=401wt.eu-S1946407AbXBIMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946407AbXBIMZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946416AbXBIMZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:25:55 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:40245 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946407AbXBIMZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:25:54 -0500
Message-ID: <45CC6855.90501@gmail.com>
Date: Fri, 09 Feb 2007 13:25:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>, linux-pm@osdl.org
Subject: Re: hwsusp defunct
References: <45C5DBBA.20502@gmail.com> <200702041452.28874.rjw@sisk.pl> <45C86405.1070902@gmail.com> <200702061855.49077.rjw@sisk.pl>
In-Reply-To: <200702061855.49077.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Tuesday, 6 February 2007 12:18, Jiri Slaby wrote:
>> running) -- how to debug both of this? Do not suspend consoles? PM_TRACE (this 
>> won't help since it completely resumes, I guess)?
> 
> First, you can try s2ram if you haven't done it already (http://en.opensuse.org/s2ram).
> It may help to get your video back after the resume.

Yes. s2ram -a 1 with minimal -mm does the job perfectly. Now, I'm going to 
involve the rest of modules world.

> If you have a COM port, it is also possible to use a serial console throughout the
> suspend/resume cycle.

Only monitor didn't go up -- dmesg was able to be grabbed without monitor :).

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
