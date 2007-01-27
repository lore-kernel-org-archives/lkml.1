Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbXA0Qg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbXA0Qg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXA0Qg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:36:56 -0500
Received: from agmk.net ([87.236.194.20]:2379 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXA0Qgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:36:55 -0500
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: 'asm' operand has impossible constraints
Date: Sat, 27 Jan 2007 17:36:30 +0100
User-Agent: KMail/1.9.6
Cc: Avi Kivity <avi@qumranet.com>, caglar@pardus.org.tr,
       kvm-devel@lists.sourceforge.net
References: <200701260140.47760.caglar@pardus.org.tr> <45BB15F1.6020600@qumranet.com>
In-Reply-To: <45BB15F1.6020600@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701271736.30271.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 of January 2007 10:05:53 Avi Kivity wrote:

> "g" appears to be equivalent to "rmi", if "i" is impossible, gcc is free
> to use "r" or "m", no?

`r'
     A register operand is allowed provided that it is in a general
     register.
`g'
     Any register, memory or immediate integer operand is allowed,
     except for registers that are not general registers.

so, it looks like g == !r for registers ( not general vs. general regs ).
