Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXLaMLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXLaMLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbXLaMLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:11:11 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21992 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbXLaMLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:11:10 -0500
Message-ID: <4778DC5B.4080601@msgid.tls.msk.ru>
Date: Mon, 31 Dec 2007 15:11:07 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Jose de la Mancha <hidalgoj@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: RAID timeout parameter accessibility request
References: <C39E7AFC.F5C7%hidalgoj@free.fr>
In-Reply-To: <C39E7AFC.F5C7%hidalgoj@free.fr>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jose de la Mancha wrote:
[]
> Jan Engelhardt wrote:
>> Not sure about Debian, but perhaps /sys/block/md0/md/safe_mode_delay
>> does something?
> 
> --> I'll check that out. Does someone know about how this "safe mode delay"
> works ?

It's about something entirely different.  This parameter tells md after
how much inactivity time to update the superblocks to indicate the array
is "clean" - so that in case of power loss w/o shutting down the array,
it will not require reconstruction.  It has nothing to do with timeouts.

By the way, linux raid is usually discussed at linux-raid@vger, not here.

/mjt
