Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbXHEAA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbXHEAA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 20:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbXHEAAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 20:00:17 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:38680 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbXHEAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 20:00:15 -0400
Message-ID: <46B51308.4010402@howardsilvan.com>
Date: Sat, 04 Aug 2007 17:00:08 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Tilman Schmidt <tilman@imap.cc>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>	 <20070726173121.70088a92@the-village.bc.nu>	 <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>	 <46D33636.7070200@microgate.com> <46AA5A0E.1050600@howardsilvan.com>	 <1185578908.2989.15.camel@x2> <46AACB4D.7080004@howardsilvan.com> <2c0942db0707280941n1b9e1f7i9c0de332286e8aac@mail.gmail.com> <46B4C393.4020506@howardsilvan.com> <46B4F8AD.3000405@microgate.com>
In-Reply-To: <46B4F8AD.3000405@microgate.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum wrote:

> Lee Howard wrote:
>
>> And in repeat tests it is quite evident that IDE disk activity is, 
>> indeed, at least part of the problem.  As IDE disk activity increases 
>> an increased amount of data coming in on the serial port goes missing.
>
>
> Lee, you mentioned 2.2.x kernels did not exhibit this problem.
>
> Was this on the same hardware you are currently testing?


Yes it was... except for the hard drive.  I have different installs of 
different operating systems on different hard drives.  I change the hard 
drive when switching between 2.2.5 and 2.6.5.

> Which 2.2.x version were you using?


The default 2.2.5 kernel that comes with RedHat 6.0.

> Was the 2.2.x serial driver also identifying the UART as a 16550A?


Yes it does.

> Can you get /proc/interrupts output
> from both the current setup and the 2.2.x setup?


Current (2.6.5):

           CPU0
  0:   14660696          XT-PIC  timer
  1:          8          XT-PIC  i8042
  2:          0          XT-PIC  cascade
  3:    1240314          XT-PIC  serial
  4:     778901          XT-PIC  serial
  8:          1          XT-PIC  rtc
 10:     111647          XT-PIC  eth0
 14:     221202          XT-PIC  ide0
 15:         34          XT-PIC  ide1
NMI:          0
ERR:          5

(2.2.5):

           CPU0
  0:       5908          XT-PIC  timer
  1:         88          XT-PIC  i8042
  2:          0          XT-PIC  cascade
  8:          2          XT-PIC  rtc
 10:        38          XT-PIC  Intel EtherExpress Pro 10/100 Ethernet
 13:          1          XT-PIC fpu
 14:        36637        XT-PIC  ide0
 15:         4          XT-PIC  ide1
NMI:          0

Thanks,

Lee.
