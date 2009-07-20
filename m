Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZGTB5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZGTB5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZGTB5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:57:51 -0400
Received: from rtr.ca ([76.10.145.34]:40170 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZGTB5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:57:50 -0400
Message-ID: <4A63CF1B.7010909@rtr.ca>
Date: Sun, 19 Jul 2009 21:57:47 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
 	branch
References: <4A631C8F.7000002@rtr.ca>	 <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>	 <4A6337C1.6080104@rtr.ca> <4A63416E.2070103@rtr.ca>	 <4A63A15F.8040804@rtr.ca> <829197380907191812v185e0869j2e5fa47483a4de4c@mail.gmail.com>
In-Reply-To: <829197380907191812v185e0869j2e5fa47483a4de4c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devin Heitmueller wrote:
>
> 2.  You hit the known analog audio issue that is preventing people
> from using analog with MythTV.  I guess you can look at the analog
> support as a work in progress - it works with most apps, but there is
> something going on specific to MythTV that I haven't isolated yet.
> Note this issue is completely related to the 950q analog project and
> has nothing to do with the xc5000 tuner improvements.
..

One additional thing I noticed here, is that when tuning analog
for the first time, the firmware is reloaded yet again.. even though
it has already been loaded once for "digital" operation.

Perhaps the extra 6-7second delay here is contributing to Myth's problems.

Cheers
