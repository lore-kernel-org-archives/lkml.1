Return-Path: <linux-kernel-owner+w=401wt.eu-S965171AbXCAPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171AbXCAPNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965175AbXCAPNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:13:47 -0500
Received: from il.qumranet.com ([82.166.9.18]:50983 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965171AbXCAPNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:13:47 -0500
Message-ID: <45E6ED26.10308@argo.co.il>
Date: Thu, 01 Mar 2007 17:11:34 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: g3vbv@blueyonder.co.uk
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E5DE32.2070902@argo.co.il> <45E6DA9A.2030301@blueyonder.co.uk>
In-Reply-To: <45E6DA9A.2030301@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sid Boyce wrote:
>> > That's very much appreciated. The point is that all vanilla kernels up
>> > to 2.6.20+ have not had the problems now seen on 2.6.20-rc1 and
>> > 2.6.20-rc2 and like other problems reported, sic framebuffer, etc.,
>> > there is a distinct likelihood that it's related to those kernels and
>> > worth reporting here where it will also be seen by the openSUSE kernel
>> > developers.
>>
>> Try running an strace on kwin and reporting the result.
>>
>>
> Modified /opt/kde3/bin/startkde as below, but got no output, not even 
> an empty file.
> strace -s 256 -f kwin --lock -o /home/lancelot/KWIN.out &

Perhaps that line is never executed.

Try running kwin from your konsole after it dies, with the strace of 
course. Oh, and put the '-o ...' before the kwin command, not after.


-- 
error compiling committee.c: too many arguments to function

