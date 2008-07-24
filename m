Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYGXMcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYGXMcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGXMce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:32:34 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:57186 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYGXMce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:32:34 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48887664.70209@cam.ac.uk>
Date: Thu, 24 Jul 2008 13:32:36 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com> <20080723191918.GC26938@trinity.fluff.org>
In-Reply-To: <20080723191918.GC26938@trinity.fluff.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Wed, Jul 23, 2008 at 06:00:29PM +0100, Jonathan Cameron wrote:
>> Dear All,
>>
>> The need for an industrialio subsystem was discussed in
>> http://lkml.org/lkml/2008/5/20/135
> 
> The name is really bad, this sounds like something for doing large
> scale industrial process control.
To a certain extent I agree, it's a pretty hideous name and I'm happy to change
it if someone can come up with a better one whilst maintaining the flexibility
to handle devices that do a range of different sensing and output tasks.
 
>> Firstly thanks to all the people who have contributed to the discussion
>> of this in the past.
>>
>> In brief the intention is provide a kernel subsystem directed towards the
>> handling on sensors (and later related output devices) such as ADC's,
>> accelerometers and many others.
> 
> We've already got an perfectly good hwmon framework, do we really need
> to do this again?
On this, see the original discussion (where using that was one of the options)
discussed.  Basically it comes down to a different set of requirements with
the ability to handle events from the device, ring buffering and higher (non
cached) update rates.  Whilst we could have bludgeoned the functionality into
that framework, it was decided that it was better to start afresh. 

Thanks,

--
Jonathan Cameron
 



