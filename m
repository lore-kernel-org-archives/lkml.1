Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbXDTTDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbXDTTDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXDTTDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:03:10 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:38000 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbXDTTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:03:09 -0400
Message-ID: <46290DED.80500@gmail.com>
Date: Fri, 20 Apr 2007 21:01:01 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Bart Trojanowski <bart@jukie.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: how to tell linux (on x86) to ignore 1M or memory
References: <20070419141804.GO32620@jukie.net>
In-Reply-To: <20070419141804.GO32620@jukie.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2007 04:18 PM, Bart Trojanowski wrote:

> I need to preserve some state from the bios before entering protected 
> mode.  For now I want to copy it into some ram accessible by real-mode, 
> say the last megabyte visible in real-mode.
> 
> What's the easiest way to have linux ignore the megabyte starting at 15M?

Note that real-mode can only access the first megabyte (*) and not the first 
16. 16MB is the 16-bit protected mode (286) limit.

(*) well, the first 1M + 64K - 16 bytes using segment FFFF assuming A20 is 
enabled and x > 1 in x86...

Rene.
