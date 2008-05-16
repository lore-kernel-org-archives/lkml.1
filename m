Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYEPFYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYEPFYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYEPFYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:24:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39867 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYEPFYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:24:44 -0400
Message-ID: <482D1A91.3050803@firstfloor.org>
Date: Fri, 16 May 2008 07:24:33 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
References: <482C02A4.80101@firstfloor.org>	<20080515184126O.tomof@acm.org>	<482C14E4.9050201@firstfloor.org> <20080516124446B.tomof@acm.org>
In-Reply-To: <20080516124446B.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Thu, 15 May 2008 12:48:04 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> I thought that KVM people want to do it per device (in the first
>>> case). So with my patchse, they can replace the dma_ops pointer in
>>> dev_archdata with what they want.
>> But where would they save the original pointer?
> 
> Yeah, we need an extra mechanism for that but it's same for the
> system-wide dma_ops pointer (i.e. without my patches), isn't it?
> 
> I'm still not sure how this patchset make it impossible to have stack
> dma_ops. These people need per-device dma_ops and we can do stack
> per-device dma_ops?

Anybody who does stack ops in your scheme would need to hook into new
device creation and an own per device saving pointer. Also there
are livetime issues when to wrap.

It's certainly possible, but likely complicated

-Andi


