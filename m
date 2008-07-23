Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYGWHOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYGWHOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYGWHOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:14:34 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4962 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750718AbYGWHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:14:33 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=-Pabf1b0GW0V_JFh4IkA:9 a=ZiK1Aija60C05RMU05M3ZUmBXJQA:4 a=l9iCJtgIvv4A:10 a=GFZTb6icBPAA:10
Message-ID: <4886DA32.6080401@sieb.net>
Date: Wed, 23 Jul 2008 00:13:54 -0700
From: Samuel Sieb <samuel@sieb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080706 Fedora/1.1.10-1.fc9 SeaMonkey/1.1.10
MIME-Version: 1.0
To: Juergen Beisert <jbe@pengutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
References: <48841A92.4020301@sieb.net> <200807210828.56821.jbe@pengutronix.de> <48856D32.1070101@sieb.net> <200807221008.27867.jbe@pengutronix.de>
In-Reply-To: <200807221008.27867.jbe@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Beisert wrote:
> On Dienstag, 22. Juli 2008, Samuel Sieb wrote:
>> Juergen Beisert wrote:
>>> linux-2.6.25/arch/x86/kernel/cyrix.c, line 151. Disable this line or
>>> change the value 0x04 according to the speed of your CPU. This tweak
>>> helps others with random hangs of their system.
>> I tried various values and various combinations of commenting out lines
>> and the only one that worked for me was to comment out the PCR1 line
>> just above it.  With that line commented out (or both of them), it
>> boots.
> 
> Hmm, then your BIOS does know more about your hardware than the kernel. ;-)
> The PCR1 line enables the incrementor. If disabled the value in PCR0 doesn't 
> matter.
> 
I did some more testing and the end result is that you can't enable the 
incrementor on this cpu.  I tried values from 0 to 7 for the PCR0 and it 
always crashed or hung (0 also gave noise all over the screen).  The 
values set by the BIOS are PCR1: 1 and PCR0: 0.
