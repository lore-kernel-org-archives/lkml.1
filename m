Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXDDQLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXDDQLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXDDQLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:11:45 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbXDDQL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:11:29 -0400
Message-ID: <4613CDB6.30306@zytor.com>
Date: Wed, 04 Apr 2007 09:09:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Russell King <rmk+lkml@arm.linux.org.uk>, Brad Boyer <flar@allandria.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <1175644642.10567.31.camel@shinybook.infradead.org> <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org> <20070403230908.GA13471@cynthia.pants.nu> <20070404085159.GB13134@flint.arm.linux.org.uk> <Pine.LNX.4.64.0704041146290.30582@anakin>
In-Reply-To: <Pine.LNX.4.64.0704041146290.30582@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> 
> Oh, and I always thought PTYs were moved to free up more minors for our
> zillions of serial ports...
> 

No, PTYs were moved because 64 ptys were woefully inadequate.  256 ptys 
were enough of a shortage for many users.

The use of 16-bit Minix device numbers was a major headache in Linux for 
many, many years.  We didn't get past that one until the 2.6 kernel series.

	-hpa
