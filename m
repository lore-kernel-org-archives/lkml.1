Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYLIQs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYLIQs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYLIQsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:48:20 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:44568 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311AbYLIQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:48:19 -0500
Message-ID: <493EA0E2.2090204@gentoo.org>
Date: Tue, 09 Dec 2008 16:46:26 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bruno.premont@restena.lu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Winter <stefan.winter@restena.lu>
Subject: Re: [2.6.27.4-5 stable regressions] Kernel boot early crash with
  low-64k reservation patches
References: <20081209083440.7569d7a0@pluto.restena.lu>
In-Reply-To: <20081209083440.7569d7a0@pluto.restena.lu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.0 c=1 a=B96dO_M4X5QA:10 a=J4wmdF8YtUcA:10 a=VwQbUJbxAAAA:8 a=_UDqDLFrGks5sXc2GckA:9 a=TVHAd2FTNG8FiuNEbOEet7cWpxwA:4 a=xfNXT5P86egA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont wrote:
> On a VMWare (ESX 3.5.0 Update 3) guest we get boot failure at the very
> beginning of boot process. (Boot successful with 2.6.27.4, failing with
> 2.6.27.x where x > 4 or just adding the 5 patches below to 2.6.27.4)
> 
> State of config option
>   CONFIG_X86_RESERVE_LOW_64K=y
> or
>   # CONFIG_X86_RESERVE_LOW_64K not set
> does not make any difference.
> 
> 
> BUG: Int 14: CR2 fbe00000
>      EDI c0385f65  ESI fbe00000  EBP c0385f80  ESP c0385f4c
>      EBX fbe00000  EDX 0000000e  ECX 00000003  EAX fbe10000
>      err 00000000  EIP c0399f8d   CS 00000062  flg 00010087
> Stack: fbe10000 fbe00000 c0385f80 c038cb6d fc001340 00000001 00000000 00000000
>        00000000 c0385fbc c03875a7 00000000 c0385fcc c0385fc0 c0389447 00100000
>        00000000 00000000 00099800 c0380000 c0385fbc 00000000 00099800 c0380000

This is http://bugzilla.kernel.org/show_bug.cgi?id=12167

Daniel

