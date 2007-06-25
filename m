Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXFYW5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXFYW5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXFYW5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:57:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37103
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbXFYW5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:57:16 -0400
Date: Mon, 25 Jun 2007 15:56:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: long-term regression
In-Reply-To: <4680445C.8000703@oracle.com>
Message-ID: <Pine.LNX.4.64.0706251555330.20356@asgard.lang.hm>
References: <Pine.LNX.4.64.0706171052240.28371@asgard.lang.hm>
 <20070621052807.cc64605d.akpm@linux-foundation.org>
 <20070621083659.dabf3a22.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706242157570.6215@asgard.lang.hm> <4680445C.8000703@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

due to the size the files are posted at http://linux.lang.hm/linux

let me know what else I can send to help.

David Lang

On Mon, 25 Jun 2007, Randy Dunlap wrote:

> Date: Mon, 25 Jun 2007 15:40:28 -0700
> From: Randy Dunlap <randy.dunlap@oracle.com>
> To: david@lang.hm
> Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
>     linux-usb-devel@lists.sourceforge.net
> Subject: Re: long-term regression
> 
> david@lang.hm wrote:
>>  On Thu, 21 Jun 2007, Randy Dunlap wrote:
>> 
>> >  Date: Thu, 21 Jun 2007 08:36:59 -0700
>> >  From: Randy Dunlap <randy.dunlap@oracle.com>
>> >  To: Andrew Morton <akpm@linux-foundation.org>
>> >  Cc: david@lang.hm, linux-kernel@vger.kernel.org,
>> >      linux-usb-devel@lists.sourceforge.net
>> >  Subject: Re: long-term regression
>> > 
>> >  On Thu, 21 Jun 2007 05:28:07 -0700 Andrew Morton wrote:
>> > 
>> > > >  On Sun, 17 Jun 2007 10:57:55 -0700 (PDT) david@lang.hm wrote:
>> > > >  I haven't had time to bisect this, but I'm having a problem on a 
>> > > >  AMD64
>> > > >  gentoo system where the printer doesn't work with recent kernels.
>> > > > 
>> > > >  2.6.18-rc3 worked
>> > > >  2.6.21.1 doesn't
>> > > >  2.6.22-rc4 doesn't
>> > > > 
>> > > >  unfortunantly the system is gooted on 2.6.18 at the moment and I'm 
>> > > >  out of
>> > > >  town so my ability to test is limited I can provide the 2.6.22-rc4
>> > > >  (attached) and 2.6.18-rc3 configs.
>> > > > 
>> > > >  dmesg appears to show the port being detected, but writes to the 
>> > > >  port
>> > > >  under newer kernels appear to complete, but no data gets to the 
>> > > >  printer.
>> > > > 
>> > > >  any suggestions other then doing the large bisect?
>> > > 
>> > >  That would be good, thanks.  Please be sure to cc linux-usb-devel on
>> > >  the results.
>> > 
>> >  OK, I'm curious about how someone deduced that this is a problem
>> >  with a USB printer vs. parallel port printer since the config file has:
>> > 
>> >  CONFIG_PRINTER=y
>> >  CONFIG_USB_PRINTER=y
>> > 
>> >  The kernel boot log should probably be posted also.
>>
>>  here is the dmesg from 2.6.22-rc4 and kern.log showing 2.6.22.-rc4 and
>>  2.6.180rc3
>>
>>  the printer not working is the parallel port.
>
> This email didn't show up on lkml or linux-usb-devel due to size limits (it 
> was 900+ KB).
>
> David, please send your working 2.6.18 config file.
>
> Can you post the kernel log files on the web somewhere?
>
>
