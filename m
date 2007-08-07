Return-Path: <linux-kernel-owner+w=401wt.eu-S966694AbXHGVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966694AbXHGVl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbXHGVSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:18:21 -0400
Received: from mail.spraycool.com ([66.236.1.89]:4589 "EHLO
	ds10965.spraycool.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965666AbXHGVSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:18:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: make menuconfig refuses to let CONFIG_X86_64=y and CONFIG_64BIT remain
Date: Tue, 7 Aug 2007 14:18:16 -0700
Message-ID: <72E9FC6E46135E4183E5211D555A2200C32749@ds10965.spraycool.com>
In-Reply-To: <72E9FC6E46135E4183E5211D555A2200C32746@ds10965.spraycool.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: make menuconfig refuses to let CONFIG_X86_64=y and CONFIG_64BIT remain
Thread-Index: AcfZHRiJSgwjHngHTsKRhCbklXB/lQAGs1Wg
References: <72E9FC6E46135E4183E5211D555A2200C32746@ds10965.spraycool.com>
From: "Maes Rich" <rmaes@spraycool.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a little more information.  I tried generating the configuration
using a 'make ARCH=x86_64 defconfig' I took the resulting file, which is
configured for x86_64 and use it as a alternative configuration file for
makeconfig and then save it without making any changes.  The newly saved
file has been restructured for 32bit.  Does this sound like a bug?


Rich Maes
Lead Systems Engineer
Isothermal Systems Research, Inc.
office: 509-232-3458
mobile: 509-701-1356
www.spraycool.com
 

-----Original Message-----
From: Maes Rich 
Sent: Tuesday, August 07, 2007 11:02 AM
To: 'linux-kernel@vger.kernel.org'
Subject: make menuconfig refuses to let CONFIG_X86_64=y and CONFIG_64BIT
remain

Hello I'm new to the list.  In the process of using make menuconfig, I
used an older config(2.6.11) to start my new configuration (2.6.17) and
notice that original settings for CONFIG_X86_64=y and CONFIG_64BIT=y are
being over ridden and replace by CONFIG_M686=y setting and
CONFIG_X86_32=y

Does this sound like new dependencies have been added for X86_64 support
and menuconfig is disabling the symbol because of a dependency shortage?

When I search on the symbol in the menuconfig GUI I see that it calls
out the flag as Symbol: X86_64 [=X86_64]... no other dependency's are
specified there.  

Can anyone explain this behavior to me?

Rich Maes
Lead Systems Engineer
Isothermal Systems Research, Inc.
office: 509-232-3458
mobile: 509-701-1356
www.spraycool.com
 

