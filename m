Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbXHNWQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbXHNWQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbXHNWAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:00:16 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3259 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935992AbXHNWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:00:11 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: why use memcpy when memmove is there?
Date: Tue, 14 Aug 2007 14:59:22 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEKAGCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <977159.24669.qm@web7606.mail.in.yahoo.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 14 Aug 2007 14:59:58 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 14 Aug 2007 14:59:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi, All
>
> We were looking at  "[kernel]/lib/string.c"
> (http://lxr.linux.no/source/lib/string.c#L500)
>
> memcpy copies a part of memory to some other location
> but It will not work for all cases of overlapping
> blocks.(if the start of destination block falls
> between the source block)
>
> while memove copes with overlapping areas.
>
> then why is memcpy present in the sources can't we
> simply do
>
> "#define memcpy memmove" in include/linux/string.h
>
> or am I missing something?

Suppose you have two vehicles, an economy car and a semi truck. The truck
can go everyplace the car can go, and the truck can carry a bigger load. So
why would you ever use the car? Answer: The car uses less gas and you don't
always need a truck.

Think about what it takes to be able to copy one block of memory to another
location when those locations might overlap. You don't always need that.

DS


