Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZGLCF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZGLCF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 22:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZGLCFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 22:05:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:13829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZGLCFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 22:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,385,1243839600"; 
   d="scan'208";a="532048245"
From: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Magnus Damm <magnus.damm@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Date: Sun, 12 Jul 2009 07:35:07 +0530
Subject: RE: [linux-pm] [RFC][PATCH] PM: Introduce core framework for
 run-time PM of I/O devices (rev. 8)
Thread-Topic: [linux-pm] [RFC][PATCH] PM: Introduce core framework for
 run-time PM of I/O devices (rev. 8)
Thread-Index: AcoCF/SFOnfcuPOtSaGB+VA3eNH6TwAfFxHQ
Message-ID: <175E0F9A9EFCEA46A65F5552BB057298BB5F43F0@bgsmsx502.gar.corp.intel.com>
References: <aec7e5c30907081952t4b88f1ccjeec6ab11b1d913b8@mail.gmail.com>
 <aec7e5c30907090831y180b0972o6dcb961dd292a3c0@mail.gmail.com>
 <175E0F9A9EFCEA46A65F5552BB057298BB5F3EA2@bgsmsx502.gar.corp.intel.com>
 <200907111308.44388.rjw@sisk.pl>
In-Reply-To: <200907111308.44388.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hi,
>
>> I am newbee to this mailing list. Please excuse me if I am talking nonsense here.
>> 
>> 
>> 
>> On Thu, Jul 9, 2009 at 10:48 PM, Alan Stern<stern@rowland.harvard.edu> wrote:
>>>> On Thu, 9 Jul 2009, Magnus Damm wrote:
>>>>
>>>> Clocks should be stopped as soon as possible without any delay. The
>>>> clock stopping is very cheap performance wise. Also, the clock
>>>> stopping is done on bus level without invoking any driver callbacks.
>>>>> Delaying the clock stopping does not make any sense to me.
>>>>
>>>> In that case the device driver or bus subsystem should manage the
>>>> device's clock directly.  There's no need to tie it in with the runtime
>>>> PM framework.  Simply start the clock before each I/O operation and
>>>> stop it afterward.
>> 
>>> It's not that easy. The clock needs to be enabled to let the hardware
>>> device perform device specific stuff. For instance, the clock for the
>>> LCD controller needs to be on to redraw the screen. When the driver
>>> knows that it's done with the clock it can notify the bus using
>>> Runtime PM.
>> 
>> Is there any plan to look into the "Clock Framework" that was developed as
>> part of OMAP and extending this to make it generic for all platforms?

>I don't have any plan to do that and I heaven't heard of anyone planning to do
>it.

Thanks for the reply Rafael. I felt if we are talking about controlling a device clock from a runtime PM framework we should look at extending the Clock framework rather than re-inventing things.

Regards,
Nithish Mahalingam
