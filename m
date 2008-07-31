Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYGaUcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYGaUcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYGaUbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:31:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:46386 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYGaUbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:31:51 -0400
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <EF0F4B21-1612-445C-AEBF-CD7B72762AD1@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <20080731152616.GA14248@windriver.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [RFC] suggested fix for 83xx/85xx PowerPC UART break bug
Date: Thu, 31 Jul 2008 15:31:43 -0500
References: <20080731152616.GA14248@windriver.com>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 31, 2008, at 10:26 AM, Paul Gortmaker wrote:

>
> This is something I'd tripped over earlier, and wanted to follow up on
> to get an acceptable fix in for everyone's benefit before it falls  
> through
> the cracks again.
>
> There seems to be an issue with recent 83xx/85xx SOC UARTs, in which  
> a break
> triggers a short lived IRQ storm (hence killing any hope of using  
> SysRQ).
> The only fix I found to work was to just ignore the bogus events that
> had the associated signature bit set.
>
> This fix is what I was using against earlier kernels, but I hate to  
> add more
> board/arch specific ifdefs to files like 8250.c, so I'm wondering if
> anyone has any other suggestions before I simply end up cleaning up  
> the
> boardlist (now ppc is dead) and respinning the patch much as it is now
> and resending.

How did you test this or generate it?  I was thinking about this the  
other day and figured we need to try and track this down with the HW  
guys.  If we can generate a simple test I can try and run it through  
the various boards/parts we have and see which ones show the issue and  
which dont.

- k
