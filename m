Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409Ab0AEIpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0AEIpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837Ab0AEIpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:45:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43464 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0AEIpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:45:42 -0500
Date: Tue, 5 Jan 2010 08:44:52 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-arch@vger.kernel.org, ebiederm@xmission.com,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/9] Add a kernel_address() that works for data too
Message-ID: <20100105084452.GA16826@flint.arm.linux.org.uk>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	linux-arch@vger.kernel.org, ebiederm@xmission.com,
	paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20100105315.789846878@firstfloor.org> <20100105021527.1AB19B17C2@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105021527.1AB19B17C2@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 03:15:27AM +0100, Andi Kleen wrote:
> 
> Add a variant of kernel_text_address() that includes kernel data.
> 
> Assumes kernel is _text ... _end - init section. True everywhere?

No.  XIP kernels have the text and data/bss separated into two distinct
address regions.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
