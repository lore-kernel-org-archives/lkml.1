Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYHVPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYHVPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYHVPZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:25:13 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:3086 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbYHVPZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:25:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Behaviour of the VM on a embedded linux
Date: Fri, 22 Aug 2008 17:25:10 +0200
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E30289D979@zuerich.BC-Int.NET>
In-Reply-To: <81b0412b0808220559w502edf03y7f318d0f3673884@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Behaviour of the VM on a embedded linux
Thread-Index: AckEVvPbIxtwFNJqQbCjbn3fwarS3gAE6oyA
References: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET> <81b0412b0808220559w502edf03y7f318d0f3673884@mail.gmail.com>
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: "Alex Riesen" <raa.lkml@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Aug 2008 15:24:48.0981 (UTC) FILETIME=[3722D050:01C9046B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Riesen wrote:
>> I'm trying to figure out whats going on an embedded system I have to
>> deal with. It's running a 2.6.24.7 kernel on 32 MBytes of RAM.
>> There is no swapping. There are some daemons and shells running and
>> - a big monolithic c++ application.
>> 
>> The application runs a lot of pthreads on different real time
>> priority levels. It looks like the application consumes  a huge
>> ammount of real memory 
>> in contrast to the assumption, that large code size is no problem due
>> to paging out pages with unused code.
> 
> Maybe the kernel wont page anything if the paging support is compiled
> out. IOW, you still need paging code even if there is now swap
> partitions. 

Alex, this is the case - I do observe normal operation of the VM subsytem - it moves memory pages dynamicaly throughout the system.
But: when I create a large file on the tmpfs a kernel OOM occurs and kills the big monolithic application instead of stealing pages
from the application. This is the fact I'm wondering about. In the past every guy told me that code size is no problem on systems
using MMUs because the system can steal pages which contain code of the application in situations of low memory. But in my situation
this is not the case.

Any ideas?

Marcel
PS: please CC me on replies
