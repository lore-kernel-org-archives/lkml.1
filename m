Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbXEJVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbXEJVqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXEJVqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:46:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbXEJVqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:46:04 -0400
Message-ID: <46439284.6080901@zytor.com>
Date: Thu, 10 May 2007 14:45:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
References: <6143.1178828419@lwn.net> <Pine.LNX.4.61.0705102326470.6426@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705102326470.6426@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 10 2007 14:20, Jonathan Corbet wrote:
>> Who knew a documentation patch would get so many reviews?  I like it...
> 
> And the next thing is register-considered-harmful.txt. Running
> 
> 	grep -Pr '\bregister\s+(unsigned|char|short|int|long|float|
> 	double|struct|union|uint|u\d+|s\d+)\b' linux-2.6.21/ | wc -l
> 
> turns up no less than 1106+2 hits.

You forgot to exclude instances with "asm" in them.

	-hpa
