Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZFVOz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZFVOz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZFVOzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:55:50 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:39842 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZFVOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rQIogPZzipEs6JSfw42Jub1096sRR4X0WMwNE93oIthgQWUnFpmzMU3vcCjGuaztsD
         WRYPsPR5IKJPk/DH29QoESlMpJmMb8nwQuwSHzuBmbu5e6mVN1GrjpX+yAZTOpcw8pVk
         ptjry55+slgqowYPI9EsEySN/YYMlDOYqFbq8=
MIME-Version: 1.0
In-Reply-To: <4A3F8BF7.6010406@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com>
	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
	 <4A3F55C7.4030909@linux.intel.com>
	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
	 <4A3F7A93.5080004@linux.intel.com>
	 <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>
	 <4A3F8BF7.6010406@linux.intel.com>
Date: Mon, 22 Jun 2009 16:55:50 +0200
Message-ID: <8db1092f0906220755v55699d5cj697b9bdf48978bd9@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Andi Kleen <ak@linux.intel.com>:

> Here's a debug patch for the poller: http://firstfloor.org/ak/mcp-debug
> Can you apply that and try again and send me the output?
>

Dmesg after resume:
http://unixy.pl/maciek/download/kernel/2.6.30-git17/pc/dmesg-2.6.30-git17-patch.txt

System hangs when uptime is roughly 5-6 minutes (when I don't change
check_interval). netconsole doesn't show anything.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
