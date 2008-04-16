Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYDPWMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYDPWMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYDPWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:12:20 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:44775 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYDPWMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:12:19 -0400
Date: Thu, 17 Apr 2008 00:12:16 +0200
Message-Id: <242011325@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clock has stopped (time/date looping over 5 seconds), things 
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/BUUAasXp4pQZJ2InDcSKH8aoFKcZtiwTihZOdQS+ln+qEH
 HHE8ozw4oKMY8CA5GdWJ39TzeZNBDCHqYbfrgU8cblnV9iT+qQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The looping ~5seconds sounds like nanosecond overflows. Might it be
>that vmware isn't delivering timer interrupts? 

seems so - at least i don`t see LOC (local timer interrupts) increase in /proc/interrupts - the only value increasing there is

1:  <value> IO-APIC-EDGE  i8042

>Could this be an interaction w/ hrt or no_hz?
don`t know - not sure what hrt or no_hz is all about in detail, so please you may tell me what i can check - i will happily deliver all input you need or do any test for you.

btw - since i thought that problem was vmware only, i didn`t put it in bugzilla - but we have at least two reports that similar behaviour has also also been seen on real hardware, so i have created a bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=10446

regards
roland




List:       linux-kernel
Subject:    Re: Clock has stopped (time/date looping over 5 secon
From:       "john stultz" <johnstul () us ! ibm ! com>
Date:       2008-04-16 17:20:25
Message-ID: 1f1b08da0804161020x7335e58qae9a237da83cb93b () mail ! gmail ! com
[Download message RAW]

On Tue, Apr 8, 2008 at 2:47 PM, Roland <devzero@web.de> wrote:
> > It _appears_ that there is a race in the kernel that can be triggered by
> > any number of hardware issues. There's another thread by Gregory Stark
> > with the same symptoms - he thinks his was fixed by replacing a bad
> > DIMM.
> >
>
>  i`d like to mention that we may have a repro-case (if it`s the same issue i
> hit within vmware):
>
>  see http://communities.vmware.com/message/909403

The looping ~5seconds sounds like nanosecond overflows. Might it be
that vmware isn't delivering timer interrupts? Could this be an
interaction w/ hrt or no_hz?

thanks
-john
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

