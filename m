Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYBQRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYBQRzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYBQRzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:55:12 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17342 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYBQRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:55:10 -0500
Message-ID: <47B874D3.5080405@oracle.com>
Date: Sun, 17 Feb 2008 09:54:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: 2.6.25-rc2-mm1 (build failure)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216213225.f5f71c35.randy.dunlap@oracle.com> <200802171223.10466.rjw@sisk.pl>
In-Reply-To: <200802171223.10466.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 17 of February 2008, Randy Dunlap wrote:
>> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
>>
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
>> When SMP=n, x86_64 build gets:
>>
>> arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
>> (.text+0xfd7f): undefined reference to `setup_trampoline'
>> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> Please try the patch at http://lkml.org/lkml/2008/2/16/301 .

Yes, fixed.  Thanks.

-- 
~Randy
