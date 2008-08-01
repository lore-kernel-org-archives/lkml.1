Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYHAMtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYHAMtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYHAMtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:49:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:34020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbYHAMtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:49:14 -0400
Cc: avorontsov@ru.mvista.com, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Message-Id: <48592693-41C0-4A71-8678-A0F44457BE47@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Ben Dooks <ben-linux@fluff.org>
In-Reply-To: <20080801104347.GM26938@trinity.fluff.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: libata badness
Date: Fri, 1 Aug 2008 07:46:50 -0500
References: <95646AC3-5385-4F59-8EBA-20F811168A87@kernel.crashing.org> <20080731210410.GA623@polina.dev.rtsoft.ru> <DAE7C7B4-CE5B-45EB-B3B4-E5491A843CD9@kernel.crashing.org> <20080801104347.GM26938@trinity.fluff.org>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1, 2008, at 5:43 AM, Ben Dooks wrote:

> On Thu, Jul 31, 2008 at 04:58:05PM -0500, Kumar Gala wrote:
>> I figured out the issue.  Its related to the interrupt routing being
>> conveyed to the code from the device tree.  We have a missing 'space'
>> causing issues.
>
> out of interest, is the M5229 attached to a single IRQ in this device
> or has the bridge been configured to route the IRQs from the IDE to
> the same pin on the PIC?

The bridge is routing interrupts via an i8259 to a single interrupt on  
the OpenPIC (primary pic).

- k
