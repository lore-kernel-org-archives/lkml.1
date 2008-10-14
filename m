Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYJNXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYJNXYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJNXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:24:29 -0400
Received: from willie.n0ano.com ([64.66.241.76]:42262 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752542AbYJNXY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:24:28 -0400
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 19:24:28 EDT
From: n0ano@n0ano.com
Date: Tue, 14 Oct 2008 17:04:32 -0600
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081014230432.GA14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <20081014235317.398c0a1a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014235317.398c0a1a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan-

Wait off a bit.  YH pointed out that early printk (I should have checked
that) already has be ability to specify a I/O address.  All I need to do
is enhance the early printk code to specify a clock frequency, I should
have that patch ready shortly.

I was kind of torn between specifying the frequency vs. the max baud rate
and went with the frequency on the off chance that some weird HW might
come out that needs a different multiplier.  I figured anybody who needs
to specify the number can do the appropriate arithmetic.

On Tue, Oct 14, 2008 at 11:53:17PM +0100, Alan Cox wrote:
> > F is the flow control, III is the I/O port address (prefix with 0x for
> > hexadecimal) and CCC is the crystal frequency.  -III and /CCC are optional
> > and can be omitted although -III must be specified if you want to set
> > /CCC.  For example, the option I use is:
> 
> I am sure real men would compute the equivalent baud rate for the clock by
> hand ;) This looks a sensible patch, will queue.
> 
> Now I wonder if uart_parse_options can be __init 
> 
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786
