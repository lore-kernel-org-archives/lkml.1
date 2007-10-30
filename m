Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbXJ3VrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbXJ3VrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXJ3VrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:47:15 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1391 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbXJ3VrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:47:14 -0400
Date: Tue, 30 Oct 2007 21:46:34 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch bug: space between left parenthesis and asterisk
Message-ID: <20071030214634.GA4574@shadowen.org>
References: <47278591.90305@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47278591.90305@freescale.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 02:27:13PM -0500, Timur Tabi wrote:
> I'm running checkpatch.pl (dated 10/17), and it complains about this line:
> 
> crc = __be32_to_cpu(* ((__be32 *) ((void *) firmware + calc_size)));
> 
> the message I get is:
> 
> ERROR: need space before that '*' (ctx:BxW)
> #721: FILE: arch/powerpc/sysdev/qe_lib/qe.c:527:
> +       crc = __be32_to_cpu(* ((__be32 *) ((void *) firmware + calc_size)));

Hmmm, i've looked back a couple of releases and this seems to get
reported correctly.  Removing this space is then silent.

ERROR: no space after that '*' (ctx:BxW)
#4: FILE: Z31.c:1:
+       crc = __be32_to_cpu(* ((__be32 *) ((void *) firmware + calc_size)));

What version is checkpatch reported as?  Also can I have the entire diff
hunk this is from in case its being caused by the context, though that
seems unlikely.

Thanks.

-apw
