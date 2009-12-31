Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZLaC5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZLaC5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZLaC5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:57:20 -0500
Received: from mail.tmr.com ([64.65.253.246]:53976 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbZLaC5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:57:20 -0500
Message-ID: <4B3C12C3.6010505@tmr.com>
Date: Wed, 30 Dec 2009 21:56:03 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Thanasis <thanasis@asyr.hopto.org>
CC: gentoo-user@lists.gentoo.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SOLVED] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org> <200912301208.54359.dirk.heinrichs@online.de> <4B3B4EF6.7030800@asyr.hopto.org>
In-Reply-To: <4B3B4EF6.7030800@asyr.hopto.org>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis wrote:
> on 12/30/2009 01:08 PM Dirk Heinrichs wrote the following:
>> Am Mittwoch 30 Dezember 2009 11:49:39 schrieb Thanasis:
>>
>>> I have a netbook (Acer Aspire One A110L) and installed a 1GB DDR2 in the
>>> available slot, for a total of 1.5GB or RAM.
>>> The BIOS reports it as 1.5GB and so does grml linux (booting from usb),
>>> but the installed gentoo linux reports only 904600 kB:
>> With more than 1G of memory, you should set CONFIG_HIGHMEM4G=y.
>>
Another benefit with PAE is that you get the benefit of the nx bit being 
available to eliminate several classes to deliberate and unintentional misbehavior.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
