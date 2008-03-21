Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYCUJIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYCUJIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYCUJHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:07:54 -0400
Received: from ozlabs.org ([203.10.76.45]:45263 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYCUJHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:07:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18403.31456.932192.862554@cargo.ozlabs.ibm.com>
Date: Fri, 21 Mar 2008 20:07:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: skumar@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Poornima Nayak <Poornima.Nayak@in.ibm.com>,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org
Subject: Re: [BUG]2.6.25-rc6:Unable to handle kernel paging request
In-Reply-To: <20080320184216.GB32259@in.ibm.com>
References: <20080318052921.GA32259@in.ibm.com>
	<18400.36670.5918.566965@cargo.ozlabs.ibm.com>
	<20080320184216.GB32259@in.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudhir Kumar writes:

> > I suggest you turn off CONFIG_SENSORS_F71805F.
> It was a new feature so I turned it on while compiling.
> I have tried by turning off CONFIG_SENSORS_F71805F but the bug
> is still present.

Do you mean that you still saw a crash in f71805f_find?  If so, then
you have some problem with the way you rebuilt the kernel, or you
didn't boot the kernel you thought you did, or possibly that
CONFIG_SENSORS_F71805F is getting turned back on by a select statement
somewhere in some Kconfig file.

If you really turned CONFIG_SENSORS_F71805F off then there would be no
f71805f_find function in the kernel.

Paul.
