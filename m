Return-Path: <linux-kernel-owner+w=401wt.eu-S934179AbYEUTac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbYEUTac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbYEUTaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:30:13 -0400
Received: from mail.quartics.com ([66.162.39.20]:30072 "EHLO mail.quartics.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbYEUTaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:30:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: VM: killing process - How to identify the problem
Date: Wed, 21 May 2008 12:30:10 -0700
Message-ID: <87A697E50899F541B77272C331CEB7440174624C@exchange.Q-DOMAIN>
In-Reply-To: <4833D2EF.5090401@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: VM: killing process - How to identify the problem
Thread-Index: Aci7FoReUgVBoZDyRvm9sv8nvLp9GgAYadQw
References: <87A697E50899F541B77272C331CEB74401746058@exchange.Q-DOMAIN> <4833D2EF.5090401@gmail.com>
From: "Mudeem Siddiqui" <mudeem@quartics.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 May 2008 19:30:10.0655 (UTC) FILETIME=[15853EF0:01C8BB79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Just curious, is is a typo?

I would say is is is a typo :)

>> 
>> __alloc_pages: 0-order allocation failed
>> __alloc_pages: 0-order allocation failed
>> __alloc_pages: 0-order allocation failed
>> 
>> 
>> and then 
>> 
>> VM: killing process 

>Caused by out of memory, a page fault couldn't be serviced due to
memory 
>exhaustion. See arch/mips/mm/fault.c.

Can this condition arise due to some other reason other than memory
leak. E.g the way the paging is being done etc because the application
calls malloc only once when it starts. I have been struggling with this
for quite a while, how would you recommend I should try to solve this?

Thanks
