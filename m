Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbXGQQBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbXGQQBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXGQQBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:01:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbXGQQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:01:20 -0400
Message-ID: <469CE7C7.1000501@zytor.com>
Date: Tue, 17 Jul 2007 09:01:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] Use standard CR8 flags, and fix TPR definition
References: <1184677946.10380.4.camel@localhost.localdomain>	 <1184678060.10380.7.camel@localhost.localdomain>	 <1184678129.10380.10.camel@localhost.localdomain>	 <1184678171.10380.12.camel@localhost.localdomain>	 <1184678216.10380.14.camel@localhost.localdomain>	 <1184678275.10380.16.camel@localhost.localdomain>	 <1184678348.10380.19.camel@localhost.localdomain>	 <1184679175.10380.25.camel@localhost.localdomain>	 <1184679256.10380.27.camel@localhost.localdomain> <1184679437.10380.31.camel@localhost.localdomain> <469CC7CC.7050102@qumranet.com>
In-Reply-To: <469CC7CC.7050102@qumranet.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 
> X86_CR8_TPR is not used in the kernel.  But is this meant to be a mask,
> or something else?
> 

Yes, a mask.

And no, it's not used, except for KVM...

	-hpa
