Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbXK0Ege@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbXK0Ege (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXK0Eg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:36:27 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:56936 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbXK0Eg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:36:26 -0500
Date: Mon, 26 Nov 2007 22:36:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
In-reply-to: <fa.c70Wy8WHP3DOaDydQ2D94+Xxx/8@ifi.uio.no>
To: bdupree@techfinesse.com
Cc: linux-kernel@vger.kernel.org
Message-id: <474B9EC1.5020304@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.c70Wy8WHP3DOaDydQ2D94+Xxx/8@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bdupree@techfinesse.com wrote:
> Question: Why is ksoftirqd eating about 5 to 10 percent of my CPU on an idle
> system? The problem occurs if I config the kernel with tickless
> support (i.e. CONFIG_TICK_ONESHOT=y).  (Thanks to "oprofile" for putting me
> onto this.)
> 
> I have noted this same problem on kernel versions: 2.6.23.1, 2.6.23.8 and
> 2.6.23.9
> 
> **************************************************************************
> *** Output from "vmstat -n 1 10" -- Note very high context switch rate ***
> *** This is on a idle machine!                                         ***
> **************************************************************************
> 
> procs -----------memory---------- ---swap-- -----io---- --system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
> id wa
>  0  0      0 1925556   4768 116104    0    0   124     2    6  7538  1  2
> 96  1
>  0  0      0 1925556   4768 116104    0    0     0     0    2 147329  0  1
> 99  0

What did oprofile show? It should be able to narrow down what 
function(s) are responsible for the CPU usage..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

