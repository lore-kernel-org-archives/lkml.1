Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbXL0Uyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbXL0Uyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 15:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXL0UyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 15:54:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:54780 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbXL0UyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 15:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PCD0B9B4lM51rhH6j1ixxN2BJNWUUmrOjN5/fzfIsa+Bj5jyjOT/CYKRLrrFLpfV6M3oAWV9riMxizx/rUACpIRFdkvJ51nNcLWR//bmEn3r28MwfDrWZEgCVGb8QZr6yRHEUkO0sVrnqLS+/Sir2v2bBwLsXyXP6u4kslTm0oc=
Message-ID: <477410F9.5030903@gmail.com>
Date: Thu, 27 Dec 2007 21:54:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Michael Tokarev <mjt@tls.msk.ru>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mxser, remove it
References: <1198762722-3222-1-git-send-email-jirislaby@gmail.com> <4773C283.5070408@msgid.tls.msk.ru> <20071227172101.GA18199@does.not.exist>
In-Reply-To: <20071227172101.GA18199@does.not.exist>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2007 06:21 PM, Adrian Bunk wrote:
> On Thu, Dec 27, 2007 at 06:19:31PM +0300, Michael Tokarev wrote:
>> Jiri Slaby wrote:
>>> (Old) mxser is obsoleted by mxser_new and scheduled for removal on Dec 2007.
>>> Remove it.
>>>
>>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>> ---
>>>  Documentation/feature-removal-schedule.txt |    8 -
>>>  drivers/char/Kconfig                       |   11 -
>>>  drivers/char/Makefile                      |    1 -
>>>  drivers/char/mxser.c                       | 3141 ----------------------------
>>>  drivers/char/mxser.h                       |  441 ----
>>>  5 files changed, 0 insertions(+), 3602 deletions(-)
>>>  delete mode 100644 drivers/char/mxser.c
>>>  delete mode 100644 drivers/char/mxser.h
>> While we're at it, how about adding a modalias for mxser_new
>> module with old (being removed) name, so that users who're
>> using the old module will not scream?  I mean, in order for
>> `modprobe mxser' to load mxser_new module.
> 
> It might even make sense to rename the mxser_new module to mxser and do 
> it the other way round - it's e.g. not clear whether a _new driver is 
> for new hardware or a new driver for old hardware.

Makes sense, if no other suggestions, I will post v2 tomorrow.

thanks,
--js
