Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXECGBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXECGBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXECGBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:01:12 -0400
Received: from gw.goop.org ([64.81.55.164]:45225 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbXECGBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:01:11 -0400
Message-ID: <46397AA1.8090606@goop.org>
Date: Wed, 02 May 2007 23:01:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: fix suspend/resume with dynamically allocated irq
 stacks
References: <20070503054809.GF26598@holomorphy.com>
In-Reply-To: <20070503054809.GF26598@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> On Wed, May 02, 2007 at 06:56:09PM -0700, Jeremy Fitzhardinge wrote:
>   
>> This fixes two bugs:
>>  - the stack allocation must be marked __cpuinit, since it gets called
>>    on resume as well.
>>  - presumably the interrupt stack should be freed on unplug if its
>>    going to get reallocated on every plug.
>> [ Only non-vmalloced stacks tested. ]
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> ---
>>  arch/i386/kernel/irq.c |   42 +++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 37 insertions(+), 5 deletions(-)
>>     
>
> Updated patch follows. Please add your Signed-off-by: if it meets your
> approval;

What does it apply to?  I'm getting conflicts if I replace my patch with
this.  Or does it replace one of your patches?

    J
