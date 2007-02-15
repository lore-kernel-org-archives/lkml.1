Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbXBONQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbXBONQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932715AbXBONQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:16:19 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2229 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714AbXBONQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:16:18 -0500
Date: Thu, 15 Feb 2007 13:16:06 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Maximus <john.maximus@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: irqdesc porting help
Message-ID: <20070215131606.GA13287@flint.arm.linux.org.uk>
Mail-Followup-To: Maximus <john.maximus@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com> <20070215103347.GA18690@linux-sh.org> <20070215104547.GA15772@flint.arm.linux.org.uk> <3634de740702150511y52985c2ak21eb663961193f20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3634de740702150511y52985c2ak21eb663961193f20@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 06:41:25PM +0530, Maximus wrote:
> Hi,
>   My drivers in 2.6.14 use statements like
>             desc->triggered = 1;
>   And desc also points to some members of irqdesc which arent in
> 2.6.19 but in 2.6.14.

But why do you have code which accesses these members?  Can you show
your code?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
