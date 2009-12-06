Return-Path: <linux-kernel-owner+w=401wt.eu-S934370AbZLFWzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbZLFWzB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 17:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934342AbZLFWy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 17:54:59 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:58706 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbZLFWy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 17:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=hmBXuh+vvGXQPO8ObNtU5LProrpNk/xi8Q9Sqs1XGtRCuLvA1JczTr/CZFmd4kHrro
         eIkmhFoNx43Iwl/4DirdB/m7ccknqzlqHvsRs2nPp+gbtnBeL3bik90GR19GLi6hgEWe
         mYfhMUCkhI3tXiI88Wga314Y9T52ig38psiEE=
References: <200912052216.19540.rjw@sisk.pl> <200912060055.36130.rjw@sisk.pl> <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain> <200912060254.10081.rjw@sisk.pl> <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain> <20091206113555.5a646713@infradead.org> <alpine.LFD.2.00.0912061144100.3560@localhost.localdomain> <20091206121803.70385c33@infradead.org>
Message-Id: <7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20091206121803.70385c33@infradead.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Sun, 6 Dec 2009 14:54:48 -0800
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 6, 2009, at 12:18 PM, Arjan van de Ven <arjan@infradead.org>  
wrote:

> On Sun, 6 Dec 2009 11:58:44 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>>
>>
>> On Sun, 6 Dec 2009, Arjan van de Ven wrote:
>>>
>>> in suspend, there's a PCI device (:1b) that does take some time,
>>> which is the audio controller. The bulk of the time is in the serio
>>> driver though..
>>
>> That serio thing is disgusting. We had serious problems with the
>> serial driver timeouts for boot-time optimizations too, didn't we?
>
> isn't serio the PS/2 stuff?

Yes, that's your PS/2 mouse (rather touchpad) and the delay comes from  
device reset (needed by some keyboard controllers - I remember HP -or  
it and keyboard will be dead at resume).

-- 
Dmitry

