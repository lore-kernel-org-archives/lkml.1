Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZHNVSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZHNVSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZHNVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:18:14 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49376 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZHNVSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:18:13 -0400
Message-ID: <4A85D490.6000701@candelatech.com>
Date: Fri, 14 Aug 2009 14:18:08 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
References: <4A81BDA6.4080804@candelatech.com>	<20090811201206.14556624@lxorguk.ukuu.org.uk>	<4A85CDCF.3060802@candelatech.com> <20090814221038.19e868a0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090814221038.19e868a0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 02:10 PM, Alan Cox wrote:
>> This worked fine, but now I'm having some more issues.  Using libata is 1/2
>> as fast as using IDE mode.  I *think* the problem might be that libsata
>> may not be using 32-bit PIO mode, but I'm not certain of that.  It seems
>> that ide mode uses PIO2 v/s PIO4 for libsata too.
>
> As of 2.6.29 libata doesn't use 32bit PIO (it shouldn't make a difference
> for most chipsets but it does for some). 2.6.30 does for some and you can
> turn it on for others if you want to test by inheriting
> ata_bmdma32_port_ops instead of ata_bmdma_port_ops

Can you give me a clue as to what code needs poking?  I'm working
on the latest 31-rc5 tree, btw.


PS.  Can't get an ide based 2.6.31-rc5 kernel to boot in F11, though it doesn't seem
to be related to ide.  I probably have something wrong in my .config.

Thanks,
ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

