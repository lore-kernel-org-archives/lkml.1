Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZDMWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZDMWUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZDMWUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:20:09 -0400
Received: from are.twiddle.net ([75.149.56.221]:53992 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbZDMWUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:20:06 -0400
Message-ID: <49E3BA95.5080204@twiddle.net>
Date: Mon, 13 Apr 2009 15:20:05 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Matt Turner <mattst88@gmail.com>, Oliver Falk <oliver@linux-kernel.at>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: alpha: half done futex implementation
References: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>	<49E39F3D.4060501@twiddle.net> <m263h8i5id.fsf@igel.home>
In-Reply-To: <m263h8i5id.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Richard Henderson <rth@twiddle.net> writes:
> 
>>   switch (op) {
>>     case FUTEX_OP_SET:
>>       __futex_atomic_op("mov %0,%1", ret, oldval, uaddr, oparg);
> 
> That should probably be "mov %4,%1\n"?

You're right.


r~
