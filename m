Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXGRXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXGRXl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936845AbXGRXdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:33:39 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:49403 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936816AbXGRXdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:33:37 -0400
Date: Wed, 18 Jul 2007 17:35:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: RHEL4 kernel-2.6.9-42.0.2.EL
In-reply-to: <fa.L02b3ieT1leTgLLxb/wPJjqu77k@ifi.uio.no>
To: andrew2.li@citigroup.com
Cc: linux-kernel@vger.kernel.org
Message-id: <469EA3B7.2040201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.L02b3ieT1leTgLLxb/wPJjqu77k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Li wrote:
> Hi guys,
> 
> I have a strange problem with cron, it is doing a segfault every minute.
> This problem happened out of the blue, according to authlog no users
> have logged onto the system in between the time it last worked and the
> time it began to fail.
> 
> The error messages from messages file is :
> Jul 18 16:16:01 host100 kernel: crond[29540]: segfault at
> 0000000000000000 rip 0000000000000000 rsp 0000007fbffbf018 error 14
> 
> Looking at arch/x86_64/mm/fault.c, this happens when a user proc is
> trying to access memory thats not in its memory map. But the address
> reported in messages doesn't match /proc/pid/maps.
> 
> Does anyone have any idea what this might be?

Looks like it's jumping to a null address. Presumably a cron bug.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

