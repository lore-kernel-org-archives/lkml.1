Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZDNJo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZDNJo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZDNJmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:42:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:41506 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856AbZDNJmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:42:31 -0400
In-Reply-To: <AE456C27-B568-4835-8843-F2A2E2D8FC32@kernel.crashing.org>
References: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com> <49E39F3D.4060501@twiddle.net> <AE456C27-B568-4835-8843-F2A2E2D8FC32@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <F29CA01F-869A-4C5C-9A3C-4F6B6ABEE901@kernel.crashing.org>
Cc: Richard Henderson <rth@twiddle.net>, Oliver Falk <oliver@linux-kernel.at>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Matt Turner <mattst88@gmail.com>, Jay Estabrook <jay.estabrook@hp.com>
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: alpha: half done futex implementation
Date: Tue, 14 Apr 2009 11:45:04 +0200
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If either the lwarx or the stwcx. faults, the routine returns -EFAULT
> and doesn't retry (label "3" is the end of the asm).
>
> If the stwcx. fails because the CPU lost the reservation, %1 isn't
> clobbered as far as I see?

Oh, "insn" writes to %1, never mind.


Segher

