Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYBDETU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYBDETU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 23:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYBDETN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 23:19:13 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:57188 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYBDETM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 23:19:12 -0500
Message-ID: <47A6923C.4060208@vandrovec.name>
Date: Sun, 03 Feb 2008 20:19:08 -0800
From: Petr Vandrovec <petr@vandrovec.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071119 Iceape/1.1.7 (Debian-1.1.7-1)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Commit f06e4ec breaks vmware
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> 
> sad to say, but f06e4ec... breaks booting the kernel in vmware 
> (bisected). Booting just stops after
> 
> 	Checking for 'hlt' instruction...
> 
> commit f06e4ec1c15691b0cfd2397ae32214fa36c90d71
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jan 30 13:32:39 2008 +0100
> 
>     x86: read_tsc sync
>     
>     make native_read_tsc() always non-speculative.
> 
> 
> Any debugging hintss?

It does not make lot of sense...  What is processor (AMD/Intel, VT/SVM, 
...), kernel (32/64), and product?

Can you try adding

monitor_control.disable_rdtscopt_bt="TRUE"

or

monitor_control.virtual_rdtsc="FALSE"

to your configuration file?
					Thanks,
						Petr


