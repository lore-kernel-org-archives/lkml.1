Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbYCUWf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbYCUWf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbYCUWfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:35:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33167 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbYCUWfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:35:46 -0400
Message-ID: <47E4383F.4030804@garzik.org>
Date: Fri, 21 Mar 2008 18:35:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [SCSI] fix media change events for polled devices
References: <200803211559.m2LFxPi6017869@hera.kernel.org>	 <47E3EC67.4050404@garzik.org>	 <1206128662.2961.37.camel@localhost.localdomain>	 <47E41C50.4020406@garzik.org>	 <1206133280.2961.45.camel@localhost.localdomain>	 <47E422F1.7080806@garzik.org>	 <1206133787.2961.52.camel@localhost.localdomain>	 <47E424E2.1030801@garzik.org> <1206136150.2961.79.camel@localhost.localdomain>
In-Reply-To: <1206136150.2961.79.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Anyway, realistically, since no CD or DVD on the market today seems to
> support the AHCI AN method, this argument is really moot ...

No, it's not.  This information is published to userspace EVEN WHEN AN 
SUPPORT IS ABSENT.  As any sane interface would do -- report a zero value.

Thus, the interface is useful even in the absence of AN.

Anyway, to recap...

before your "fix":

	userspace interface always reflected list of events sent
	via my new API

after your "fix":

	events may or may not be reflected in userspace interface,
	who knows?

Is that distinction so difficult to see?

This interface, like it or not, is in 2.6.24, which means its published 
and "out there."

This is a clear regression from 2.6.24.

supported_events' value was accurate in 2.6.24.  Now it is not.

	Jeff


