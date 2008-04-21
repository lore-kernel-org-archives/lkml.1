Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbYDUTqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbYDUTqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYDUTqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:46:10 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:52332 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbYDUTqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:46:09 -0400
Message-ID: <480CEEED.2040705@aknet.ru>
Date: Mon, 21 Apr 2008 23:45:49 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Joseph Fannin <jfannin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org> <s5hwsmrcvow.wl%tiwai@suse.de>
In-Reply-To: <s5hwsmrcvow.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 18 Apr 2008 22:13:43 -0400 Joseph Fannin <jfannin@gmail.com> wrote:
>>>>
>>>>> On Fri, Apr 18, 2008 at 01:47:57AM -0700, Andrew Morton wrote:
>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 
>>>>> I've been seeing the following backtraces since 2.6.25-rc8-mm1 -- at
>>>>> least, since that's the earliest -mm I've built in a while.  I don't
>>>>> get the same in mainline.

As a quick workaround, say N to INPUT_PCSPKR:
  │ Prompt: PC Speaker support
  │   Location:
  │     -> Device Drivers
  │       -> Input device support
  │         -> Generic input layer (needed for keyboard, mouse, ...)
(INPUT │
  │           -> Miscellaneous devices (INPUT_MISC [=y])
