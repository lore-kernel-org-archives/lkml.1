Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYGXQLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYGXQLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYGXQL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:11:28 -0400
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:45643 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYGXQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:11:27 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4888A9B3.8070004@gmail.com>
Date: Thu, 24 Jul 2008 17:11:31 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Ben Dooks <ben-linux@fluff.org>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com> <20080723191918.GC26938@trinity.fluff.org> <20080724074124.GB2254@local> <20080724100144.GA8301@fluff.org.uk> <20080724153816.GE2254@local>
In-Reply-To: <20080724153816.GE2254@local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Well, it says "Industrial I/O". To me, this means it handles I/O devices
>>> typically found in industrial applications.
>>>       
>> Yes, industrial is generally process control of manufacturing
>> processes which in my view is making this sound like it is limiting
>> the field of operations.
>>     
> OK, I agree.
>   
Agreed, though don't yet have a better idea.
In fact my use cases are all really embedded systems anyway.
>> All the applications we would currently need are things like
>> handheld PDA type devices which are hardly 'industrial' or small
>> consumer measurement systems.
>>     
>
> Well, though the _use_ of such devices might not be "industrial",
> _technically_ they are very similar to embedded systems found in
> automation or other industrial equipment.
>
> Many of these devices (all that have mmappable memory) can be handled
> with a UIO driver, but for the rest (mostly stuff connected to serial
> busses), it's important to have a subsystem in the kernel. I really
> don't care too much about its name. BTW, before UIO was first published,
> its internal name was "Industrial I/O" ;-)
>   
lol. We could try and make it the standard working name for all new
subsystems ;)
--
Jonathan Cameron
