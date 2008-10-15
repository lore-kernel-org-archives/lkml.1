Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYJOCDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYJOCDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYJOCDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:03:08 -0400
Received: from mail.lang.hm ([64.81.33.126]:55775 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYJOCDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:03:07 -0400
Date: Tue, 14 Oct 2008 19:03:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Glenn Powers <glenn@meaning.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Perfectly Random
In-Reply-To: <48F54BB1.7040706@meaning.com>
Message-ID: <alpine.DEB.1.10.0810141902020.6244@asgard.lang.hm>
References: <48F54BB1.7040706@meaning.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Glenn Powers wrote:

> THE KERNEL MODULE WILL:
>
> Copy the current CPU clock tick of these interrupts to a ring buffer.
>
> THEN:
>
> A Linux-RTAI application will compute the entropy and transfer it to 
> /dev/random, a database or a network interface.
>
> THEN:
>
> The system can be tuned.
>
> THEN:
>
> The best tunings can be incorporated into the "RandomNuclear" module.

why can't userspace talk to this external hardware and get a count from 
it, and then insert it into the random pool without involving any kernel 
module?

also, anything that depends on the exact CPU clock tick of when interrupts 
happen has just sacraficed a LOT of it's randomness to the particulars of 
various motherboards.

David Lang
