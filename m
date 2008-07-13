Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYGMTw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYGMTw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYGMTwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:52:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:59453 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbYGMTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GSjTldF9LJBKonuucqrRQweiKmDGyAdu06VNDS15Cgd566rwqJfPO82dnMAgrIiUGz
         UZTC/dBj9+o2YxfXL20+1+1nRohwfOx3WY0i1pr5YROTPP/6zvLB4kx9gTEqIIA8c9MO
         q3rqRMwyAMnWfttwXWTK9r3dVEKHDw37v7xnY=
Message-ID: <19f34abd0807131252k5499e6e2sc93f8cd70f488b7e@mail.gmail.com>
Date: Sun, 13 Jul 2008 21:52:40 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <dd18b0c30807131234n5edf3e1dt93022a45d427b1fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>
	 <dd18b0c30807131234n5edf3e1dt93022a45d427b1fd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 9:34 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Sun, Jul 13, 2008 at 6:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
>> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
>> Submitter       : Justin Mattock <justinmattock@gmail.com>
>> Date            : 2008-05-16 6:17 (59 days old)
>> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>>                  http://lkml.org/lkml/2008/5/18/168
>>                  http://lkml.org/lkml/2008/5/25/195
>> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view

I didn't follow the discussion, but I may contribute the following information:

This message first appears in my logs on May 16. That was with kernel
version 2.6.24.5-85.fc8. The kernel I used before that was
2.6.24.4-64.fc8 (May 3). My logs go back to November 8
(2.6.23.1-42.fc8). So we can hardly consider this a regression since
2.6.25, but rather one since 2.6.24?

(I'll also note that this message appears quite infrequently here.
Only 42 times in 219 boot-ups. So it would be hard to bisect, but I'm
guessing the error was introduced somewhere between 2.6.24.4 and
2.6.24.5.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
