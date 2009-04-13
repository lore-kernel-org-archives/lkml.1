Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbZDMVy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbZDMVy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbZDMVyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:54:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54273 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbZDMVyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:54:40 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Richard Henderson <rth@twiddle.net>
Cc: Matt Turner <mattst88@gmail.com>, Oliver Falk <oliver@linux-kernel.at>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: alpha: half done futex implementation
References: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>
	<49E39F3D.4060501@twiddle.net>
X-Yow: Are you still an ALCOHOLIC?
Date: Mon, 13 Apr 2009 23:54:34 +0200
In-Reply-To: <49E39F3D.4060501@twiddle.net> (Richard Henderson's message of
	"Mon, 13 Apr 2009 13:23:25 -0700")
Message-ID: <m263h8i5id.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Henderson <rth@twiddle.net> writes:

>   switch (op) {
>     case FUTEX_OP_SET:
>       __futex_atomic_op("mov %0,%1", ret, oldval, uaddr, oparg);

That should probably be "mov %4,%1\n"?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
