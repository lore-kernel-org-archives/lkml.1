Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbYFFNvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbYFFNvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYFFNv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:51:27 -0400
Received: from gw.goop.org ([64.81.55.164]:59725 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbYFFNv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:51:27 -0400
Message-ID: <484940B5.6030307@goop.org>
Date: Fri, 06 Jun 2008 14:50:45 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATED] x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com>	<484901A3.3040401@goop.org> <87lk1iu2km.fsf@basil.nowhere.org>
In-Reply-To: <87lk1iu2km.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 43bits might be actally safer because of potential sign bugs.
>
> But of course it won't work anyways likely.
>   

I thought about it, but I think we're pretty consistent about putting 
pfns into unsigned types.  But, yes, you're very marginal at that point.

    J
