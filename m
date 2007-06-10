Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbXFJSCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbXFJSCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbXFJSCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:02:35 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:44982 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbXFJSCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:02:34 -0400
Date: Sun, 10 Jun 2007 12:02:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: system clock slow on Athlon AMD64 since 2.6.21
In-reply-to: <fa.o/++pztnlzntJf5yY17Qd7cKHWw@ifi.uio.no>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: ghpille@hotmail.com, linux-kernel@vger.kernel.org
Message-id: <466C3C98.8060800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.o/++pztnlzntJf5yY17Qd7cKHWw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> On Fri, 08 Jun 2007 10:14:03 +0200, Gerard H. Pille wrote:
>> [1.] One line summary of the problem:
>> Since I switched from 2.6.20 to 2.6.21 on my Athlon AMD64 laptop, the system 
>> time is slow - about 1' on 15'.
> 
> According to your system description it seems that you have a
> Targa Visionary laptop with a VIA chipset and a Mobile Athlon64.
> If so, then you probably have the same problem I reported some time
> ago: see <http://marc.info/?l=linux-kernel&m=117681226421346&w=2>
> and the followup messages. The conclusion was that the chipset's
> ACPI PM timer slows down when the CPU is in C2.
> 
> The workaround is to boot with processor.max_cstate=1.

Which, if true, is extremely bizarre, as the whole point and reason for 
existence of the ACPI PM timer is that it NOT do this, and remain at the 
same rate regardless of CPU power management changes..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

