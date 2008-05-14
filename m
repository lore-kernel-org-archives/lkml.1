Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYENJza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYENJza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYENJzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:55:22 -0400
Received: from gw.goop.org ([64.81.55.164]:33396 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbYENJzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:55:21 -0400
Message-ID: <482AB6FC.7020202@goop.org>
Date: Wed, 14 May 2008 10:55:08 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] common implementation of iterative div/mod
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>	<481DF3D8.3010108@shaw.ca>	<a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>	<48217674.8080903@goop.org>	<48231959.4050406@goop.org> <20080513234627.30476c20.akpm@linux-foundation.org> <482A95BB.1000001@goop.org> <482AA3BD.1030600@firstfloor.org>
In-Reply-To: <482AA3BD.1030600@firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> You would need to annotate it and have a separate object file for the
> different sections. Also it would need to be compiled PIC.
>
> Inlining is better.

BTW, I'm seeing the memcpy() in __vdso_gettimeofday() not being inlined.

    J
