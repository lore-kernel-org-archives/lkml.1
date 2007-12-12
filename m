Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbXLLOce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbXLLOce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXLLOc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:32:26 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46015 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXLLOc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:32:26 -0500
Message-ID: <475FF094.8000709@keyaccess.nl>
Date: Wed, 12 Dec 2007 15:30:44 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Juergen Beisert <juergen127@kreuzholzen.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <200712120959.59952.juergen127@kreuzholzen.de>
In-Reply-To: <200712120959.59952.juergen127@kreuzholzen.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 09:59, Juergen Beisert wrote:

> $ for i in `seq 5`; do ./port80; sleep 1; done
> cycles: out 5260, in 2372
> cycles: out 5260, in 2384
> cycles: out 5260, in 2323
> cycles: out 5270, in 2382
> cycles: out 5259, in 2323
> 
> $ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 7
> model name      : Pentium III (Katmai)
> stepping        : 3
> cpu MHz         : 501.208

This one's really wrong. This would be 10 microsecs. I suppose the 
machine/bus was heavily loaded or something?

> $ for i in `seq 5`; do ./port80; sleep 1; done
> cycles: out 1214, in 1095
> cycles: out 1215, in 1094
> cycles: out 1214, in 1095
> cycles: out 1216, in 1095
> cycles: out 1213, in 1093
> 
> $ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 11
> model name      : Intel(R) Celeron(TM) CPU                1000MHz

This one's normal again...

Rene.
