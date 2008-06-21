Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612AbYFUOA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbYFUOA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYFUOAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:00:48 -0400
Received: from rtr.ca ([76.10.145.34]:4664 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbYFUOAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:00:48 -0400
Message-ID: <485D098E.3080109@rtr.ca>
Date: Sat, 21 Jun 2008 10:00:46 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hdparm -M acoustic management for sata disks?
References: <1214043295.17302.16.camel@localhost>
In-Reply-To: <1214043295.17302.16.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> Dear all,
> 
> why is acoustic management via hdparm not supported for sata disks?
> 
> # hdparm -M /dev/sda
> 
> /dev/sda:
>  acoustic      = not supported
..

No, that means that your *drive* doesn't support it.
Check for yourself, with "hdparm -I /dev/sda | grep Acoustic".

..
> Is there any patch flying around that already enables this or even any
> ETA in the current mainstream?
..

No patch required -- hdparm (newer versions) already do this correctly.

Cheers
